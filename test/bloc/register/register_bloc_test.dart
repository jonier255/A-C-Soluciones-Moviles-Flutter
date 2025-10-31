import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_event.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_state.dart';
import 'package:flutter_a_c_soluciones/model/register_request_model.dart';
import 'package:flutter_a_c_soluciones/model/register_response_model.dart';
import 'package:flutter_a_c_soluciones/repository/service_api_register.dart';
import 'package:http/http.dart' as http;

// Manual mock for success case
class MockAPIServiceRegisterSuccess implements APIServiceRegister {
  @override
  Future<RegisterResponseModel> register(RegisterRequestModel model) async {
    return RegisterResponseModel(message: 'Success');
  }
  
  @override
  var client = http.Client();
}

// Manual mock for failure case
class MockAPIServiceRegisterFailure implements APIServiceRegister {
  @override
  Future<RegisterResponseModel> register(RegisterRequestModel model) async {
    throw Exception('Registration failed');
  }

  @override
  var client = http.Client();
}

void main() {
  group('RegisterBloc', () {
    late RegisterBloc registerBloc;

    test('initial state is RegisterInitial', () {
      registerBloc = RegisterBloc(apiServiceRegister: MockAPIServiceRegisterSuccess());
      expect(registerBloc.state, RegisterInitial());
    });

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RegisterSuccess] when RegisterButtonPressed is added and registration is successful.',
      build: () => RegisterBloc(apiServiceRegister: MockAPIServiceRegisterSuccess()),
      act: (bloc) => bloc.add(RegisterButtonPressed(
        nombre: 'test',
        apellido: 'test',
        numero_de_cedula: '12345',
        correo_electronico: 'test@test.com',
        telefono: '1234567890',
        direccion: 'test address',
        contrasenia: 'password',
      )),
      expect: () => [
        RegisterLoading(),
        RegisterSuccess(message: "Registro exitoso"),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RegisterFailure] when RegisterButtonPressed is added and registration fails.',
      build: () => RegisterBloc(apiServiceRegister: MockAPIServiceRegisterFailure()),
      act: (bloc) => bloc.add(RegisterButtonPressed(
        nombre: 'test',
        apellido: 'test',
        numero_de_cedula: '12345',
        correo_electronico: 'test@test.com',
        telefono: '1234567890',
        direccion: 'test address',
        contrasenia: 'password',
      )),
      expect: () => [
        RegisterLoading(),
        RegisterFailure(error: 'Exception: Registration failed'),
      ],
    );
  });
}