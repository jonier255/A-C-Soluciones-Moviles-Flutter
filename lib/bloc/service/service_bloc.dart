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
          totalPages: response.totalPages,
        ));
      } catch (e) {
        emit(ServiceFailure(error: e.toString()));
      }
    });

    // Maneja la carga de más servicios (siguientes páginas)
    on<LoadMoreServices>((event, emit) async {
      final currentState = state;
      if (currentState is ServiceSuccess) {
        // Emite un estado especial mientras carga (mantiene los servicios actuales)
        emit(ServiceLoadingMore(currentState.services));
        
        try {
          final response = await this.repository.getServices(page: event.page);
          
          emit(ServiceSuccess(
            response.services,
            hasMorePages: response.hasMorePages,
            currentPage: event.page,
            totalPages: response.totalPages,
          ));
        } catch (e) {
          // Si hay error, vuelve al estado anterior exitoso
          emit(currentState);
        }
      }
    });
  }
}
