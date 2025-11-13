class UpdateTechnicalRequest {
  final int id;
  final String nombre;
  final String apellido;
  final String numeroCedula;
  final String correoElectronico;
  final String rol;


  UpdateTechnicalRequest({
    required this.nombre,
    required this.apellido,
    required this.numeroCedula,
    required this.correoElectronico,
    required this.id,
    required this.rol
  });

  factory UpdateTechnicalRequest.fromJson(Map<String, dynamic> json) {
    return UpdateTechnicalRequest(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      numeroCedula: json['numero_de_cedula']?.toString() ?? '',
      correoElectronico: json['correo_electronico'] ?? '',
      rol: json['rol'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "apellido": apellido,
        "numero_cedula": numeroCedula,
        "correo_electronico": correoElectronico,
        "rol": rol,
      };
}
