import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/service_repository.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository repository;

  ServiceBloc({ServiceRepository? repository})
      : repository = repository ?? ServiceRepository(),
        super(ServiceInitial()) {
    // Maneja la carga inicial de servicios (primera página)
    on<LoadServices>((event, emit) async {
      emit(ServiceLoading());
      try {
        final response = await this.repository.getServices(page: 1);
        emit(ServiceSuccess(
          response.services,
          hasMorePages: response.hasMorePages,
          currentPage: 1,
        ));
      } catch (e) {
        emit(ServiceFailure(error: e.toString()));
      }
    });

    // Maneja la carga de más servicios (siguientes páginas)
    on<LoadMoreServices>((event, emit) async {
      // Solo carga más si estamos en estado exitoso y hay más páginas
      final currentState = state;
      if (currentState is ServiceSuccess && currentState.hasMorePages) {
        // Emite un estado especial mientras carga más (mantiene los servicios actuales)
        emit(ServiceLoadingMore(currentState.services));
        
        try {
          final response = await this.repository.getServices(page: event.page);
          
          // Combina los servicios actuales con los nuevos
          final allServices = [...currentState.services, ...response.services];
          
          emit(ServiceSuccess(
            allServices,
            hasMorePages: response.hasMorePages,
            currentPage: event.page,
          ));
        } catch (e) {
          // Si hay error, vuelve al estado anterior exitoso
          emit(currentState);
          // Podríamos emitir un estado de error específico aquí si lo necesitamos
        }
      }
    });
  }
}
