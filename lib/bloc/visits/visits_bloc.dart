import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/client/service_api_service.dart';
import 'package:flutter_a_c_soluciones/bloc/client/service_event.dart';
import 'package:flutter_a_c_soluciones/bloc/client/service_state.dart';

class VisitsBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository repository;

  VisitsBloc(this.repository) : super(ServiceInitial()) {
    on<FetchService>((event, emit) async {
      emit(ServiceLoading());
      try {
        final services = await repository.getServices();
        emit(ServiceSuccess(services));
      } catch (e) {
        emit(ServiceError(e.toString()));
      }
    });
  }
}
