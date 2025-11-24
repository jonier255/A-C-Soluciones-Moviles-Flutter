part of 'edit_profile_admin_bloc.dart';

abstract class EditProfileAdminEvent extends Equatable {
  const EditProfileAdminEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminProfile extends EditProfileAdminEvent {}

class UpdateAdminProfile extends EditProfileAdminEvent {
  final UpdateAdminRequest adminData;

  const UpdateAdminProfile({required this.adminData});

  @override
  List<Object> get props => [adminData];
}

