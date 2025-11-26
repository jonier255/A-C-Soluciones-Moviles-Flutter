class LoginResponseModel {
  final String token;
  final Cliente user;

  LoginResponseModel({
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String,
      user: Cliente.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}

class Cliente {
  final int id;
  final String rol;
  final String nombre;
  final String correoElectronico;

  Cliente({
    required this.id,
    required this.rol,
    required this.nombre,
    required this.correoElectronico,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as int,
      rol: json['rol'] as String,
      nombre: json['nombre'] as String,
      correoElectronico: json['correo_electronico'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rol': rol,
      'nombre': nombre,
      'email': correoElectronico,
    };
  }
}
