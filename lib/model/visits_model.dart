class VisitsModel {
  final int id;
  final DateTime fechaProgramada;
  final int duracionEstimada;
  final String estado;
  final String notasPrevias;
  final String notasPosteriores;
  final DateTime fechaCreacion;
  final int solicitudId;
  final int tecnicoId;
  final int servicioId;

  VisitsModel({
    required this.id,
    required this.fechaProgramada,
    required this.duracionEstimada,
    required this.estado,
    required this.notasPrevias,
    required this.notasPosteriores,
    required this.fechaCreacion,
    required this.solicitudId,
    required this.tecnicoId,
    required this.servicioId,
  });

  factory VisitsModel.fromJson(Map<String, dynamic> json) {
    return VisitsModel(
      id: json['id'] as int? ?? 0,
      fechaProgramada: DateTime.parse(json['fecha_programada']),
      duracionEstimada: json['duracion_estimada'] as int? ?? 0,
      estado: json['estado'] as String? ?? 'desconocido',
      notasPrevias: json['notas_previas'] ?? '',
      notasPosteriores: json['notas_posteriores'] ?? '',
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      solicitudId: json['solicitud_id_fk'] as int? ?? 0,
      tecnicoId: json['tecnico_id_fk'] as int? ?? 0,
      servicioId: json['servicio_id_fk'] as int? ?? 0,
    );
  }
}
