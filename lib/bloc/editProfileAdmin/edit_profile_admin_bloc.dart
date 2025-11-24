import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_a_c_soluciones/model/administrador/admin_model.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/service_AdminUpdateProfile.dart';

part 'edit_profile_admin_event.dart';
part 'edit_profile_admin_state.dart';

class EditProfileAdminBloc extends Bloc<EditProfileAdminEvent, EditProfileAdminState> {
  final AdminUpdateProfileRepository adminUpdateProfileRepository;

  EditProfileAdminBloc({required this.adminUpdateProfileRepository})
      : super(EditProfileAdminInitial()) {
    on<LoadAdminProfile>(_onLoadAdminProfile);
    on<UpdateAdminProfile>(_onUpdateAdminProfile);
  }

  Future<void> _onLoadAdminProfile(
    LoadAdminProfile event,
    Emitter<EditProfileAdminState> emit,
  ) async {
    emit(EditProfileAdminLoading());
    try {
      final admin = await adminUpdateProfileRepository.getAdminProfile();
      emit(EditProfileAdminLoaded(admin));
    } catch (e) {
      emit(EditProfileAdminFailure(e.toString()));
    }
  }

  Future<void> _onUpdateAdminProfile(
    UpdateAdminProfile event,
    Emitter<EditProfileAdminState> emit,
  ) async {
    emit(EditProfileAdminLoading());
    try {
      await adminUpdateProfileRepository.updateAdminProfile(event.adminData);
      emit(EditProfileAdminSuccess());
    } catch (e) {
      emit(EditProfileAdminFailure(e.toString()));
    }
  }
}


