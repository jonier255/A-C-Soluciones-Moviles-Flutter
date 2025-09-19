import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/login_event.dart';
import 'package:flutter_a_c_soluciones/bloc/login_state.dart';
import 'package:flutter_a_c_soluciones/model/login_request_model.dart';
import 'package:flutter_a_c_soluciones/repository/api_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        

        final loginRequest =
            LoginRequestModel(email: event.email, password: event.password);

        final response = await APIService.login(loginRequest);

        if (response.token != null) {
          emit(LoginSuccess(token: response.token!));
        } else {
          emit(LoginFailure(error: 'Login Failed'));
        }
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
