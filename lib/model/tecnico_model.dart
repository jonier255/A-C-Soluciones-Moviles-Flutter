class Tecnico {
  final int id;
  final String nombre;
  final String apellido;

  Tecnico({
    required this.id,
    required this.nombre,
    required this.apellido,
  });

  factory Tecnico.fromJson(Map<String, dynamic> json) {
    return Tecnico(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
    );
  }
}
