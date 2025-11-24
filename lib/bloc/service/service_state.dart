import 'package:equatable/equatable.dart';
import '../../model/servicio_model.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

// Estado cuando se están cargando más servicios (no la primera página)
class ServiceLoadingMore extends ServiceState {
  final List<Servicio> currentServices;  // Los servicios que ya tenemos
  
  const ServiceLoadingMore(this.currentServices);
  
  @override
  List<Object> get props => [currentServices];
}

class ServiceSuccess extends ServiceState {
  final List<Servicio> services;
  final bool hasMorePages;  // Si hay más páginas para cargar
  final int currentPage;    // Página actual
  final int totalPages;     // Total de páginas disponibles
  
  const ServiceSuccess(
    this.services, {
    this.hasMorePages = true,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  @override
  List<Object> get props => [services, hasMorePages, currentPage, totalPages];
}

class ServiceFailure extends ServiceState {
  final String error;
  const ServiceFailure({required this.error});

  @override
  List<Object> get props => [error];
}
