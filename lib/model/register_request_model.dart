class RegisterRequestModel {
  String? nombre;
  String? apellido;
  String? numero_de_cedula;
  String? correo_electronico;
  String? telefono;
  String? direccion;
  String? contrasenia;

  RegisterRequestModel({
    this.nombre,
    this.apellido,
    this.numero_de_cedula,
    this.correo_electronico,
    this.telefono,
    this.direccion,
    this.contrasenia,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    data['numero_de_cedula'] = numero_de_cedula;
    data['correo_electronico'] = correo_electronico;
    data['telefono'] = telefono;
    data['direccion'] = direccion;
    data['contrasenia'] = contrasenia;
    return data;
  }
}