class Tecnico {
  final int id;
  final String rol;
  final String nombre;
  final String apellido;
  final String numeroCedula;
  final String correoElectronico;
  final String telefono;
  final String cargo; 
  final String password; 



  Tecnico({
    required this.id,
    required this.rol,
    required this.nombre,
    required this.apellido,
    required this.numeroCedula,
    required this.correoElectronico,
    required this.telefono,
    required this.cargo,
    required this.password, 
    
  });

  factory Tecnico.fromJson(Map<String, dynamic> json) {
    return Tecnico(
      id: json['id'] ?? 0,
      rol: json['rol'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      numeroCedula: json['numero_cedula']?.toString() ?? '',
      correoElectronico: json['correo_electronico'] ?? '',
      telefono: json['telefono'] ?? '',
      cargo: json['cargo'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
