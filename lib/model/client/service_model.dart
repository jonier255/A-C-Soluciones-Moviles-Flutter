class ServiceModel {
  final int id;
  final String nombre;
  final String descripcion;
  final String estado;
  final int price;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  final int creadaPorFk;
  final int? idAdministrador;
  final int? tecnicoId;

  ServiceModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.estado,
    required this.price,
    required this.fechaCreacion,
    required this.fechaModificacion,
    required this.creadaPorFk,
    this.idAdministrador,
    this.tecnicoId,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'] ?? 'activo',
      price: json['price'] ?? 0, // Si tu backend lo llama diferente, cámbialo
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaModificacion: DateTime.parse(json['fecha_modificacion']),
      creadaPorFk: json['creada_por_fk'] ?? 0,
      idAdministrador: json['id_administrador'],
      tecnicoId: json['tecnico_id'],
    );
  }

  /// ✅ Método para convertir el modelo a JSON (por ejemplo, al enviar datos al backend)
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'nombre': nombre,
  //     'descripcion': descripcion,
  //     'estado': estado,
  //     'price': price,
  //     'fecha_creacion': fechaCreacion.toIso8601String(),
  //     'fecha_modificacion': fechaModificacion.toIso8601String(),
  //     'creada_por_fk': creadaPorFk,
  //     'id_administrador': idAdministrador,
  //     'tecnico_id': tecnicoId,
  //   };
  // }
}
