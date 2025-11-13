import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/service_repository.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository repository;

  ServiceBloc({ServiceRepository? repository})
      : repository = repository ?? ServiceRepository(),
        super(ServiceInitial()) {
    on<LoadServices>((event, emit) async {
      emit(ServiceLoading());
      try {
        final services = await this.repository.getServices();
        emit(ServiceSuccess(services));
      } catch (e) {
        emit(ServiceFailure(error: e.toString()));
      }
    });
  }
}
