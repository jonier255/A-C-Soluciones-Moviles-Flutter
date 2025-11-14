part of 'edit_profile_client_bloc.dart';

abstract class EditProfileClientEvent extends Equatable {
  const EditProfileClientEvent();

  @override
  List<Object> get props => [];
}

class LoadClientProfile extends EditProfileClientEvent {}

class UpdateClientProfile extends EditProfileClientEvent {
  final ClientProfileModel clientData;

  const UpdateClientProfile({required this.clientData});

  @override
  List<Object> get props => [clientData];
}

