part of 'servicios_bloc.dart';

abstract class ServiciosEvent extends Equatable {
  const ServiciosEvent();

  @override
  List<Object> get props => [];
}

class LoadServicios extends ServiciosEvent {}
