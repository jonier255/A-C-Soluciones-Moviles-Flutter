class RegisterRequestModel {
  String? nombre;
  String? apellido;
  String? numeroDeCedula;
  String? correoElectronico;
  String? telefono;
  String? direccion;
  String? contrasenia;

  RegisterRequestModel({
    this.nombre,
    this.apellido,
    this.numeroDeCedula,
    this.correoElectronico,
    this.telefono,
    this.direccion,
    this.contrasenia,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    data['numero_de_cedula'] = numeroDeCedula;
    data['correo_electronico'] = correoElectronico;
    data['telefono'] = telefono;
    data['direccion'] = direccion;
    data['contrasenia'] = contrasenia;
    return data;
  }
}