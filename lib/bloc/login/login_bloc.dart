import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_event.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_state.dart';
import 'package:flutter_a_c_soluciones/model/login_request_model.dart';
import 'package:flutter_a_c_soluciones/repository/service_api_login.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _storageService = SecureStorageService();

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        final loginRequest =
            LoginRequestModel(email: event.email, password: event.password);

        final response = await APIService.login(loginRequest);

        if (response.token != null && response.user != null) {
          // Guardar el token en el almacenamiento seguro
          await _storageService.saveToken(response.token!);

          final user = response.user!;
          final String role = user['rol'] ?? 'user';
          final String userId = user['id'].toString();

          if (role.toLowerCase() == 'admin' || role.toLowerCase() == 'administrador') {
            await _storageService.saveAdminId(userId);
          } else if (role.toLowerCase() == 'cliente') {
            await _storageService.saveClienteId(userId);
          } else if (role.toLowerCase() == 'tecnico') {
            await _storageService.saveTechnicalId(userId);
          }

          final String userName = user['nombre'] ?? 'Usuario';
          final String userEmail = user['email'] ?? '';

          emit(LoginSuccess(
            token: response.token!,
            role: role,
            nombre: userName,
            correoElectronico: userEmail,
          ));
        } else {
          emit(LoginFailure(error: 'Login Failed: Token or user data is null'));
        }
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }

  // Métodos para acceder a los datos del usuario desde otros widgets
  String? get currentUserName {
    return state is LoginSuccess ? (state as LoginSuccess).nombre : null;
  }

  String? get currentUserEmail {
    return state is LoginSuccess
        ? (state as LoginSuccess).correoElectronico
        : null;
  }

  String? get currentUserRole {
    return state is LoginSuccess ? (state as LoginSuccess).role : null;
  }

  bool get isLoggedIn {
    return state is LoginSuccess;
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
