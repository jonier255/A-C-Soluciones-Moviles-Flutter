abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String nombre;
  final String apellido;
  final String numeroDeCedula;
  final String correoElectronico;
  final String telefono;  
  final String direccion;
  final String contrasenia;

  RegisterButtonPressed({
    required this.nombre,
    required this.apellido,
    required this.numeroDeCedula,
    required this.correoElectronico,
    required this.telefono,
    required this.direccion,
    required this.contrasenia,
  });
}
