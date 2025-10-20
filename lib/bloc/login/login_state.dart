abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;
  final String role;
  final String nombre;
  final String correoElectronico;

  LoginSuccess({
    required this.token,
    required this.role,
    required this.nombre,
    required this.correoElectronico,
  });
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
