import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_a_c_soluciones/model/login_request_model.dart';
import 'package:flutter_a_c_soluciones/model/login_response_model.dart';

class APIService {
  static var client = http.Client();

  static Future<LoginResponseModel> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('http://10.0.2.2:8000/api/login');

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      final storage = SecureStorageService();
      final token = responseBody['token'] as String?;
      if (token != null) {
        await storage.saveToken(token);
      }
      final administrador = responseBody['administrador'];
      if (administrador != null) {
        await storage.saveAdminId(administrador.toString());
      }

      // Guardar datos del usuario
      final user = responseBody['user'] as Map<String, dynamic>?;
      if (user != null) {
        await storage.saveUserData({
          'cliente_id': (user['id'] ?? 0).toString(),
          'user_name': (user['nombre'] ?? user['user_name'] ?? '').toString(),
          'user_email': (user['correo_electronico'] ?? user['email'] ?? user['user_email'] ?? '').toString(),
        });
      }

      // Retornar el modelo de respuesta
      return loginResponseJson(response.body);
    } else {
      throw Exception('Error al iniciar sesión: ${response.statusCode}');
    }
  }
}
