part of 'edit_profile_technical_bloc.dart';


abstract class EditProfileTechnicalState extends Equatable {
  const EditProfileTechnicalState();

  @override
  List<Object> get props => [];
}

class EditProfileTechnicalInitial extends EditProfileTechnicalState {}

class EditProfileTechnicalLoading extends EditProfileTechnicalState {}

class EditProfileTechnicalLoaded extends EditProfileTechnicalState {
  final UpdateTechnicalRequest technical;

  const EditProfileTechnicalLoaded(this.technical);

  @override
  List<Object> get props => [technical];
}

class EditProfileTechnicalSuccess extends EditProfileTechnicalState {}

class EditProfileTechnicalFailure extends EditProfileTechnicalState {
  final String error;
  final Map<String, String>? fieldErrors;

  const EditProfileTechnicalFailure(this.error, {this.fieldErrors});

  @override
  List<Object> get props => [error, fieldErrors ?? {}];
}
