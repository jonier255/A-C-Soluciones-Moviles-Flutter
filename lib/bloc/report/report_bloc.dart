import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;

  ReportBloc({required this.reportRepository}) : super(ReportInitial()) {
    on<CreateReport>(_onCreateReport);
  }

  void _onCreateReport(
    CreateReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportCreationLoading());
    try {
      await reportRepository.createMaintenanceSheet(
        visitId: event.visitId,
        introduccion: event.introduccion,
        detallesServicio: event.detallesServicio,
        observaciones: event.observaciones,
        estadoAntes: event.estadoAntes,
        descripcionTrabajo: event.descripcionTrabajo,
        materialesUtilizados: event.materialesUtilizados,
        estadoFinal: event.estadoFinal,
        tiempoDeTrabajo: event.tiempoDeTrabajo,
        recomendaciones: event.recomendaciones,
        fechaDeMantenimiento: event.fechaDeMantenimiento,
        fotoEstadoAntes: event.fotoEstadoAntes,
        fotoEstadoFinal: event.fotoEstadoFinal,
        fotoDescripcionTrabajo: event.fotoDescripcionTrabajo,
      );
      emit(ReportCreationSuccess());
    } catch (e) {
      try {
        final message = e.toString();
        final jsonStartIndex = message.indexOf('{');
        if (jsonStartIndex != -1) {
          final jsonString = message.substring(jsonStartIndex);
          final responseData = jsonDecode(jsonString) as Map<String, dynamic>;

          if (responseData.containsKey('errors')) {
            final errors = responseData['errors'] as Map<String, dynamic>;
            final fieldErrors = errors.map((key, value) => MapEntry(key, value.toString()));
            emit(ReportCreationFailure('Por favor, corrija los errores.', fieldErrors: fieldErrors));
          } else {
            emit(ReportCreationFailure(responseData['message'] ?? 'Ocurrió un error inesperado.'));
          }
        } else {
          emit(ReportCreationFailure(e.toString()));
        }
      } catch (_) {
        emit(ReportCreationFailure(e.toString()));
      }
    }
  }
}