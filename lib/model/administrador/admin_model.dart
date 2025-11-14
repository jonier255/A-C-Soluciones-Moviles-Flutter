class UpdateAdminRequest {
  final int id;
  final String nombre;
  final String apellido;
  final String numeroCedula;
  final String correoElectronico;
  final String rol;


  UpdateAdminRequest({
    required this.nombre,
    required this.apellido,
    required this.numeroCedula,
    required this.correoElectronico,
    required this.id,
    required this.rol
  });

  factory UpdateAdminRequest.fromJson(Map<String, dynamic> json) {
    return UpdateAdminRequest(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      numeroCedula: json['numero_cedula']?.toString() ?? '',
      correoElectronico: json['correo_electronico'] ?? '',
      rol: json['rol'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      "id": id,
      "nombre": nombre,
      "apellido": apellido,
      // send numero_cedula as int when possible, otherwise send string
      "numero_cedula": int.tryParse(numeroCedula) ?? numeroCedula,
      "correo_electronico": correoElectronico,
      "rol": rol,
      };
}
