class Solicitud {
  final int id;
  final String fechaSolicitud;
  final String estado;
  final String direccionServicio;
  final String descripcion;
  final String comentarios;
  final int? tecnicoId;
  final int? clienteId;
  final int? servicioId;

  Solicitud({
    required this.id,
    required this.fechaSolicitud,
    required this.estado,
    required this.direccionServicio,
    required this.descripcion,
    required this.comentarios,
    this.tecnicoId,
    this.clienteId,
    this.servicioId,
  });

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      id: json['id'] ?? 0,
      fechaSolicitud: json['fecha_solicitud'] ?? '',
      estado: json['estado'] ?? 'pendiente',
      direccionServicio: json['direccion_servicio'] ?? '',
      descripcion: json['descripcion'] ?? '',
      comentarios: json['comentarios'] ?? '',
      tecnicoId: json['tecnico_id'],
      clienteId: json['cliente_id'],
      servicioId: json['servicio_id'],
    );
  }
}
