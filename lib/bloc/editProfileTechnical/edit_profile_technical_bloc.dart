import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_a_c_soluciones/model/technical/technical_model.dart';
import 'package:flutter_a_c_soluciones/repository/services_technical/service_TechnicalUpdateProfile.dart';

part 'edit_profile_technical_event.dart';
part 'edit_profile_technical_state.dart';

class EditProfileTechnicalBloc extends Bloc<EditProfileTechnicalEvent, EditProfileTechnicalState> {
  final TechnicalUpdateProfileRepository technicalUpdateProfileRepository;

  EditProfileTechnicalBloc({required this.technicalUpdateProfileRepository})
      : super(EditProfileTechnicalInitial()) {
    on<LoadTechnicalProfile>(_onLoadTechnicalProfile);
    on<UpdateTechnicalProfile>(_onUpdateTechnicalProfile);
  }

  void _onLoadTechnicalProfile(
    LoadTechnicalProfile event,
    Emitter<EditProfileTechnicalState> emit,
  ) async {
    emit(EditProfileTechnicalLoading());
    try {
      final technical = await technicalUpdateProfileRepository.getTechnicalProfile();
      emit(EditProfileTechnicalLoaded(technical));
    } catch (e) {
      emit(EditProfileTechnicalFailure(e.toString()));
    }
  }

  void _onUpdateTechnicalProfile(
    UpdateTechnicalProfile event,
    Emitter<EditProfileTechnicalState> emit,
  ) async {
    emit(EditProfileTechnicalLoading());
    try {
      await technicalUpdateProfileRepository.updateTechnicalProfile(event.technicalData);
      emit(EditProfileTechnicalSuccess());
      final technical = await technicalUpdateProfileRepository.getTechnicalProfile(); // Reload data
      emit(EditProfileTechnicalLoaded(technical)); // Emit loaded state with fresh data
    } catch (e) {
      emit(EditProfileTechnicalFailure(e.toString()));
    }
  }
}
