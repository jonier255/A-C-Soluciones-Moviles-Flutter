part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class CreateReport extends ReportEvent {
  final int visitId;
  final String introduccion;
  final String detallesServicio;
  final String observaciones;
  final String estadoAntes;
  final String descripcionTrabajo;
  final String materialesUtilizados;
  final String estadoFinal;
  final String tiempoDeTrabajo;
  final String recomendaciones;
  final String fechaDeMantenimiento;
  final XFile? fotoEstadoAntes;
  final XFile? fotoEstadoFinal;
  final XFile? fotoDescripcionTrabajo;

  const CreateReport({
    required this.visitId,
    required this.introduccion,
    required this.detallesServicio,
    required this.observaciones,
    required this.estadoAntes,
    required this.descripcionTrabajo,
    required this.materialesUtilizados,
    required this.estadoFinal,
    required this.tiempoDeTrabajo,
    required this.recomendaciones,
    required this.fechaDeMantenimiento,
    this.fotoEstadoAntes,
    this.fotoEstadoFinal,
    this.fotoDescripcionTrabajo,
  });

  @override
  List<Object?> get props => [
        visitId,
        introduccion,
        detallesServicio,
        observaciones,
        estadoAntes,
        descripcionTrabajo,
        materialesUtilizados,
        estadoFinal,
        tiempoDeTrabajo,
        recomendaciones,
        fechaDeMantenimiento,
        fotoEstadoAntes,
        fotoEstadoFinal,
        fotoDescripcionTrabajo,
      ];
}