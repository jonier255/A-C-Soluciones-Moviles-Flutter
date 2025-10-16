import '../../model/servicio_model.dart';

abstract class ServiceState {}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceSuccess extends ServiceState {
  final List<Servicio> services;
  ServiceSuccess(this.services);
}

class ServiceError extends ServiceState {
  final String message;
  ServiceError(this.message);
}
