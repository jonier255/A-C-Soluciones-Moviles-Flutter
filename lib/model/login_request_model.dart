
class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
        email: json["correo_electronico"] as String,
        password: json["contrasenia"] as String,
      );
    }  
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'correo_electronico': email.trim(),
      'contrasenia': password.trim(),
    };
    return map;
  }
}//falta la respuesta
