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
    // ignore: avoid_print
    print('🔵 [ReportBloc] Iniciando creación de reporte...');
    emit(ReportCreationLoading());
    
    try {
      // ignore: avoid_print
      print('🔵 [ReportBloc] Llamando al repositorio...');
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
      // ignore: avoid_print
      print('✅ [ReportBloc] Reporte creado exitosamente. Emitiendo ReportCreationSuccess...');
      emit(ReportCreationSuccess());
      // ignore: avoid_print
      print('✅ [ReportBloc] Estado ReportCreationSuccess emitido.');
    } catch (e) {
      // ignore: avoid_print
      print('❌ [ReportBloc] Error capturado: $e');
      try {
        final message = e.toString();
        final jsonStartIndex = message.indexOf('{');
        if (jsonStartIndex != -1) {
          final jsonString = message.substring(jsonStartIndex);
          final responseData = jsonDecode(jsonString) as Map<String, dynamic>;

          if (responseData.containsKey('errors')) {
            final errors = responseData['errors'] as Map<String, dynamic>;
            final fieldErrors = errors.map((key, value) => MapEntry(key, value.toString()));
            // ignore: avoid_print
            print('❌ [ReportBloc] Emitiendo error con fieldErrors');
            emit(ReportCreationFailure('Por favor, corrija los errores.', fieldErrors: fieldErrors));
          } else {
            // ignore: avoid_print
            print('❌ [ReportBloc] Emitiendo error con mensaje');
            emit(ReportCreationFailure(responseData['message'] ?? 'Ocurrió un error inesperado.'));
          }
        } else {
          // ignore: avoid_print
          print('❌ [ReportBloc] Emitiendo error genérico');
          emit(ReportCreationFailure(e.toString()));
        }
      } catch (parseError) {
        // ignore: avoid_print
        print('❌ [ReportBloc] Error al parsear: $parseError');
        emit(ReportCreationFailure(e.toString()));
      }
    }
  }
}