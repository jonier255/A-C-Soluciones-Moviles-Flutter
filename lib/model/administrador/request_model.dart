class Request {
  final int id;
  final DateTime fechaSolicitud;
  final String descripcion;
  final String direccionServicio;
  final String? comentarios;
  final String estado;
  final int clienteId;
  final int? adminId;
  final int servicioId;

  Request({
    required this.id,
    required this.fechaSolicitud,
    required this.descripcion,
    required this.direccionServicio,
    this.comentarios,
    required this.estado,
    required this.clienteId,
    this.adminId,
    required this.servicioId,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] ?? 0,
      fechaSolicitud: DateTime.parse(json['fecha_solicitud']),
      descripcion: json['descripcion'] ?? '',
      direccionServicio: json['direccion_servicio'] ?? '',
      comentarios: json['comentarios'],
      estado: json['estado'] ?? 'desconocido',
      clienteId: json['cliente_id_fk'] ?? 0,
      adminId: json['admin_id_fk'],
      servicioId: json['servicio_id_fk'] ?? 0,
    );
  }
}