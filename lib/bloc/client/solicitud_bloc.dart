import 'package:flutter_a_c_soluciones/bloc/client/solicitud_event.dart';
import 'package:flutter_a_c_soluciones/bloc/client/solicitud_state.dart';
import 'package:flutter_a_c_soluciones/repository/client/solicitud_api_solicitud.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SolicitudBloc extends Bloc<SolicitudEvent, SolicitudState> {
  final SolicitudApiRepository repository;

  SolicitudBloc(this.repository) : super(SolicitudInitial()) {
    on<FetchSolicitud>((event, emit) async {
      emit(SolicitudLoading());
      try {
        final solicitudes = await repository.getSolicitudes();
        emit(SolicitudSuccess(solicitudes));
      } catch (e) {
        emit(SolicitudError(e.toString()));
      }
    });
  }
}
