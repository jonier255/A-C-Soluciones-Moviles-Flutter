import '../../../model/administrador/admin_model.dart';

abstract class AdminsState {}

class AdminsInitial extends AdminsState {}

class AdminsLoading extends AdminsState {}

class AdminsSuccess extends AdminsState {
  final List<UpdateAdminRequest> admins;

  AdminsSuccess(this.admins);
}

class AdminsError extends AdminsState {
  final String message;

  AdminsError(this.message);
}

