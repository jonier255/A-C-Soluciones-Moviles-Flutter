part of 'servicios_bloc.dart';

abstract class ServiciosState extends Equatable {
  const ServiciosState();

  @override
  List<Object> get props => [];
}

class ServiciosInitial extends ServiciosState {}

class ServiciosLoading extends ServiciosState {}

class ServiciosLoaded extends ServiciosState {
  final List<Servicio> servicios;

  const ServiciosLoaded({required this.servicios});

  @override
  List<Object> get props => [servicios];
}

class ServiciosError extends ServiciosState {
  final String message;

  const ServiciosError({required this.message});

  @override
  List<Object> get props => [message];
}
