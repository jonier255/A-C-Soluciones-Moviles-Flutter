import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_event.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_state.dart';
import 'package:flutter_a_c_soluciones/model/register_request_model.dart';
import 'package:flutter_a_c_soluciones/repository/service_api_register.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final numeroDeCedulaController = TextEditingController();
  final correoElectronicoController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final contraseniaController = TextEditingController();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      try {
        final registerRequest = RegisterRequestModel(
          nombre: event.nombre,
          apellido: event.apellido,
          numero_de_cedula: event.numero_de_cedula,
          correo_electronico: event.correo_electronico,
          telefono: event.telefono,
          direccion: event.direccion,
          contrasenia: event.contrasenia,
        );

        final response = await APIServiceRegister.register(registerRequest);

        if (response.message != null) {
          emit(RegisterSuccess(message: response.message!));
        } else {
          emit(RegisterFailure(error: 'Registration Failed'));
        }
      } catch (e) {
        emit(RegisterFailure(error: e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    nombreController.dispose();
    apellidoController.dispose();
    numeroDeCedulaController.dispose();
    correoElectronicoController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    contraseniaController.dispose();
    return super.close();
  }
}
