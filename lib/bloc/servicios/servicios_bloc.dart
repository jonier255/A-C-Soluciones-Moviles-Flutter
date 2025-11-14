import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_a_c_soluciones/model/servicio_model.dart';
import 'package:flutter_a_c_soluciones/repository/service_repository.dart';

part 'servicios_event.dart';
part 'servicios_state.dart';

class ServiciosBloc extends Bloc<ServiciosEvent, ServiciosState> {
  final ServiceRepository serviceRepository;

  ServiciosBloc({required this.serviceRepository}) : super(ServiciosInitial()) {
    on<LoadServicios>((event, emit) async {
      emit(ServiciosLoading());
      try {
        final servicios = await serviceRepository.getServices();
        emit(ServiciosLoaded(servicios: servicios));
      } catch (e) {
        emit(ServiciosError(message: e.toString()));
      }
    });
  }
}
