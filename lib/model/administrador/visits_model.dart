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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fechaProgramada: DateTime.parse(json['fecha_programada']),
      duracionEstimada: int.tryParse(json['duracion_estimada']?.toString() ?? '0') ?? 0,
      estado: json['estado'] as String? ?? 'desconocido',
      notasPrevias: json['notas_previas'] ?? '',
      notasPosteriores: json['notas_posteriores'] ?? '',
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      solicitudId: int.tryParse(json['solicitud_id_fk']?.toString() ?? '0') ?? 0,
      tecnicoId: json['tecnico'] != null && json['tecnico']['id'] != null
          ? int.tryParse(json['tecnico']['id'].toString()) ?? 0
          : int.tryParse(json['tecnico_id_fk']?.toString() ?? '0') ?? 0,
      servicioId: int.tryParse(json['servicio_id_fk']?.toString() ?? '0') ?? 0,
    );
  }
}
