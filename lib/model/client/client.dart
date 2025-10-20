class Client {
  final int id;
  final String rol;
  final String nombre;
  final String email;

  Client({
    required this.id,
    required this.rol,
    required this.nombre,
    required this.email,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      rol: json['rol'],
      nombre: json['nombre'],
      email: json['email'],
    );
  }
}
