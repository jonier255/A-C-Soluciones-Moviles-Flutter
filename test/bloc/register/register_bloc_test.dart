
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_event.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_state.dart';
import 'package:flutter_a_c_soluciones/model/register_request_model.dart';
import 'package:flutter_a_c_soluciones/repository/service_api_register.dart';

class MockAPIServiceRegister extends Mock implements APIServiceRegister {}

void main() {
  group('RegisterBloc', () {
    late RegisterBloc registerBloc;
    late MockAPIServiceRegister mockAPIServiceRegister;

    setUp(() {
      mockAPIServiceRegister = MockAPIServiceRegister();
      registerBloc = RegisterBloc(apiServiceRegister: mockAPIServiceRegister);
    });

    tearDown(() {
      registerBloc.close();
    });

    test('initial state is RegisterInitial', () {
      expect(registerBloc.state, RegisterInitial());
    });

    blocTest<RegisterBloc, RegisterState>(
      'emits [RegisterLoading, RegisterSuccess] when RegisterButtonPressed is added and registration is successful.',
      build: () {
        when(mockAPIServiceRegister.register(any)).thenAnswer((_) async => Future.value());
        return registerBloc;
      },
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
      build: () {
        when(mockAPIServiceRegister.register(any)).thenThrow(Exception('Registration failed'));
        return registerBloc;
      },
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
