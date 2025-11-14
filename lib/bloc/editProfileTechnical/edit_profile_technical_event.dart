part of 'edit_profile_technical_bloc.dart';

abstract class EditProfileTechnicalEvent extends Equatable {
  const EditProfileTechnicalEvent();

  @override
  List<Object> get props => [];
}

class LoadTechnicalProfile extends EditProfileTechnicalEvent {}

class UpdateTechnicalProfile extends EditProfileTechnicalEvent {
  final UpdateTechnicalRequest technicalData;

  const UpdateTechnicalProfile({required this.technicalData});

  @override
  List<Object> get props => [technicalData];
}
