abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String nombre;
  final String apellido;
  final String numero_de_cedula;
  final String correo_electronico;
  final String telefono;
  final String direccion;
  final String contrasenia;

  RegisterButtonPressed({
    required this.nombre,
    required this.apellido,
    required this.numero_de_cedula,
    required this.correo_electronico,
    required this.telefono,
    required this.direccion,
    required this.contrasenia,
  });
}
