import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

// Evento para cargar la primera página de servicios
class LoadServices extends ServiceEvent {}

// Evento para cargar más servicios (paginación)
class LoadMoreServices extends ServiceEvent {
  final int page;
  
  const LoadMoreServices(this.page);
  
  @override
  List<Object> get props => [page];
}
