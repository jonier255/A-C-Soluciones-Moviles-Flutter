class ClientProfileModel {
  final int id;
  final String numeroDeCedula;
  final String nombre;
  final String apellido;
  final String correoElectronico;
  final String telefono;
  final String direccion;
  final String? contrasenia; // Opcional para actualización
  final String rol;
  final String estado;

  ClientProfileModel({
    required this.id,
    required this.numeroDeCedula,
    required this.nombre,
    required this.apellido,
    required this.correoElectronico,
    required this.telefono,
    required this.direccion,
    this.contrasenia,
    required this.rol,
    required this.estado,
  });

  factory ClientProfileModel.fromJson(Map<String, dynamic> json) {
    return ClientProfileModel(
      id: json['id'] ?? 0,
      numeroDeCedula: json['numero_de_cedula']?.toString() ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      correoElectronico: json['correo_electronico'] ?? '',
      telefono: json['telefono']?.toString() ?? '',
      direccion: json['direccion'] ?? '',
      contrasenia: json['contrasenia'],
      rol: json['rol'] ?? 'cliente',
      estado: json['estado'] ?? 'activo',
    );
  }

  Map<String, dynamic> toJson({bool includePassword = false}) {
    final Map<String, dynamic> data = {
      'numero_de_cedula': numeroDeCedula,
      'nombre': nombre,
      'apellido': apellido,
      'correo_electronico': correoElectronico,
      'telefono': telefono,
      'direccion': direccion,
    };

    if (includePassword && contrasenia != null && contrasenia!.isNotEmpty) {
      data['contrasenia'] = contrasenia;
    }

    return data;
  }

  ClientProfileModel copyWith({
    int? id,
    String? numeroDeCedula,
    String? nombre,
    String? apellido,
    String? correoElectronico,
    String? telefono,
    String? direccion,
    String? contrasenia,
    String? rol,
    String? estado,
  }) {
    return ClientProfileModel(
      id: id ?? this.id,
      numeroDeCedula: numeroDeCedula ?? this.numeroDeCedula,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      correoElectronico: correoElectronico ?? this.correoElectronico,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      contrasenia: contrasenia ?? this.contrasenia,
      rol: rol ?? this.rol,
      estado: estado ?? this.estado,
    );
  }
}

