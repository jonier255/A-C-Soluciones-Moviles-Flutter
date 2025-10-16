class Servicio {
  final int id;
  final String nombre;
  final String descripcion;
  final String estado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;

  Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.estado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'] ?? '',
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaModificacion: DateTime.parse(json['fecha_modificacion']),
    );
  }
}

class TaskModel {
  final int id;
  final DateTime fechaProgramada;
  final int duracionEstimada;
  final String estado;
  final String? notasPrevias;
  final String? notasPosteriores;
  final DateTime fechaCreacion;
  final Servicio servicio;

  TaskModel({
    required this.id,
    required this.fechaProgramada,
    required this.duracionEstimada,
    required this.estado,
    this.notasPrevias,
    this.notasPosteriores,
    required this.fechaCreacion,
    required this.servicio,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      fechaProgramada: DateTime.parse(json['fecha_programada']),
      duracionEstimada: json['duracion_estimada'] ?? 0,
      estado: json['estado'] ?? 'desconocido',
      notasPrevias: json['notas_previas'],
      notasPosteriores: json['notas_posteriores'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      servicio: Servicio.fromJson(json['servicio']),
    );
  }
}