part of 'edit_profile_client_bloc.dart';

abstract class EditProfileClientState extends Equatable {
  const EditProfileClientState();

  @override
  List<Object> get props => [];
}

class EditProfileClientInitial extends EditProfileClientState {}

class EditProfileClientLoading extends EditProfileClientState {}

class EditProfileClientLoaded extends EditProfileClientState {
  final ClientProfileModel client;

  const EditProfileClientLoaded(this.client);

  @override
  List<Object> get props => [client];
}

class EditProfileClientSuccess extends EditProfileClientState {}

class EditProfileClientFailure extends EditProfileClientState {
  final String error;

  const EditProfileClientFailure(this.error);

  @override
  List<Object> get props => [error];
}

