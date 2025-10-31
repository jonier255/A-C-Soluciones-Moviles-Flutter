import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_a_c_soluciones/model/login_request_model.dart';
import 'package:flutter_a_c_soluciones/model/login_response_model.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';

class APIService {
  static var client = http.Client();

  static Future<LoginResponseModel> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.parse('https://flutter-58c3.onrender.com/api/login');

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      final storage = SecureStorageService();
      await storage.saveToken(responseBody['token']);
      await storage.saveAdminId(responseBody['administrador'].toString());

      // Retornar el modelo de respuesta
      return loginResponseJson(response.body);
    } else {
      throw Exception('Error al iniciar sesión: ${response.statusCode}');
    }
  }
}
