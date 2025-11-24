import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_event.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_state.dart';
import 'package:flutter_a_c_soluciones/model/register_request_model.dart';
import 'package:flutter_a_c_soluciones/repository/service_api_register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final numeroDeCedulaController = TextEditingController();
  final correoElectronicoController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final contraseniaController = TextEditingController();

  final APIServiceRegister apiServiceRegister;

  RegisterBloc({APIServiceRegister? apiServiceRegister})
      : apiServiceRegister = apiServiceRegister ?? APIServiceRegister(),
        super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      try {
        final registerRequest = RegisterRequestModel(
          nombre: event.nombre,
          apellido: event.apellido,
          numeroDeCedula: event.numeroDeCedula,
          correoElectronico: event.correoElectronico,
          telefono: event.telefono,
          direccion: event.direccion,
          contrasenia: event.contrasenia,
        );

        // Se asume éxito si no hay excepción, ya que el backend devuelve el objeto de usuario en lugar de un mensaje.
        await this.apiServiceRegister.register(registerRequest);
        emit(const RegisterSuccess(message: "Registro exitoso"));
      } catch (e) {
        emit(RegisterFailure(error: e.toString()));
      }
    });
  }


}
