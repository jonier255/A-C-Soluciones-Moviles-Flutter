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
