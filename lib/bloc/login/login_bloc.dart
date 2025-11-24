import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_event.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_state.dart';
import 'package:flutter_a_c_soluciones/model/login_request_model.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';
import 'package:flutter_a_c_soluciones/repository/service_api_login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

        if (response.token != null) {
          await _storageService.saveToken(response.token!);

          Map<String, dynamic> decodedToken =
              JwtDecoder.decode(response.token!);
          final String role = decodedToken['rol'] ?? 'user';

          final String userName = decodedToken['nombre'] ?? 'Usuario';
          final String userEmail = decodedToken['email'] ?? '';

          
          try {
            // Obtener el ID del token
            final possibleId = decodedToken['id'] ?? decodedToken['sub'] ?? decodedToken['user_id'] ?? decodedToken['admin_id'];
            if (possibleId != null) {
              final idStr = possibleId.toString();
              if (idStr.isNotEmpty && idStr.toLowerCase() != 'null') {
                // Guardar el ID según el rol del usuario
                if (role.toLowerCase() == 'admin' || role.toLowerCase() == 'administrador') {
                  final existingAdminId = await _storageService.getAdminId();
                  if (existingAdminId == null) {
                    await _storageService.saveAdminId(idStr);
                  }
                } else if (role.toLowerCase() == 'tecnico') {
                  await _storageService.saveTechnicalId(idStr);
                } else if (role.toLowerCase() == 'cliente') {
                  await _storageService.saveClienteId(idStr);
                }
              }
            }
          } catch (_) {}

          emit(LoginSuccess(
            token: response.token!,
            role: role,
            nombre: userName,
            correoElectronico: userEmail,
          ));
        } else {
          emit(LoginFailure(error: 'Login Failed'));
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
