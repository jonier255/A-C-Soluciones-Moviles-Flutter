import 'package:flutter_a_c_soluciones/repository/client/service_api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/client/service_event.dart';
import 'package:flutter_a_c_soluciones/bloc/client/service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository repository;

  ServiceBloc(this.repository) : super(ServiceInitial()) {
    on<FetchService>((event, emit) async {
      emit(ServiceLoading());
      try {
        final sevice = await repository.getServices();
        emit(ServiceSuccess(sevice));
      } catch (e) {
        emit(ServiceError(e.toString()));
      }
    });
  }
}
