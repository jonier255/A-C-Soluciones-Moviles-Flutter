import 'package:equatable/equatable.dart';
import '../../model/servicio_model.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceSuccess extends ServiceState {
  final List<Servicio> services;
  const ServiceSuccess(this.services);

  @override
  List<Object> get props => [services];
}

class ServiceFailure extends ServiceState {
  final String error;
  const ServiceFailure({required this.error});

  @override
  List<Object> get props => [error];
}
