import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_a_c_soluciones/model/client/client_profile_model.dart';
import 'package:flutter_a_c_soluciones/repository/client/client_profile_repository.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';

part 'edit_profile_client_event.dart';
part 'edit_profile_client_state.dart';

class EditProfileClientBloc extends Bloc<EditProfileClientEvent, EditProfileClientState> {
  final ClientProfileRepository clientProfileRepository;

  EditProfileClientBloc({required this.clientProfileRepository})
      : super(EditProfileClientInitial()) {
    on<LoadClientProfile>(_onLoadClientProfile);
    on<UpdateClientProfile>(_onUpdateClientProfile);
  }

  void _onLoadClientProfile(
    LoadClientProfile event,
    Emitter<EditProfileClientState> emit,
  ) async {
    emit(EditProfileClientLoading());
    
    // Cargar datos del login desde SecureStorage
    final storage = SecureStorageService();
    final clienteIdStr = await storage.getUserData('cliente_id');
    final userName = await storage.getUserData('user_name');
    final userEmail = await storage.getUserData('user_email');
    
    // Crear un perfil con los datos del login
    if (clienteIdStr != null && userName != null && userEmail != null) {
      final clienteId = int.tryParse(clienteIdStr) ?? 0;
      final client = ClientProfileModel(
        id: clienteId,
        numeroDeCedula: '',
        nombre: userName,
        apellido: '',
        correoElectronico: userEmail,
        telefono: '',
        direccion: '',
        rol: 'cliente',
        estado: 'activo',
      );
      emit(EditProfileClientLoaded(client));
    } else {
      emit(EditProfileClientFailure('No se encontraron datos del usuario'));
    }
  }

  void _onUpdateClientProfile(
    UpdateClientProfile event,
    Emitter<EditProfileClientState> emit,
  ) async {
    emit(EditProfileClientLoading());
    try {
      await clientProfileRepository.updateClientProfile(event.clientData);
      emit(EditProfileClientSuccess());
    } catch (e) {
      emit(EditProfileClientFailure(e.toString()));
    }
  }
}

