part of 'edit_profile_admin_bloc.dart';


abstract class EditProfileAdminState extends Equatable {
  const EditProfileAdminState();

  @override
  List<Object> get props => [];
}

class EditProfileAdminInitial extends EditProfileAdminState {}

class EditProfileAdminLoading extends EditProfileAdminState {}

class EditProfileAdminLoaded extends EditProfileAdminState {
  final UpdateAdminRequest admin;

  const EditProfileAdminLoaded(this.admin);

  @override
  List<Object> get props => [admin];
}

class EditProfileAdminSuccess extends EditProfileAdminState {}

class EditProfileAdminFailure extends EditProfileAdminState {
  final String error;

  const EditProfileAdminFailure(this.error);

  @override
  List<Object> get props => [error];
}
