import 'dart:convert';

import 'package:flutter_a_c_soluciones/model/login_request_model.dart';
import 'package:flutter_a_c_soluciones/model/login_response_model.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';
import 'package:http/http.dart' as http;

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

      String? adminId;
      String? tryExtractId(dynamic data) {
        if (data == null) return null;
        if (data is int) return data.toString();
        if (data is String) {
          final s = data.trim();
          if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
          return null;
        }
        if (data is Map) {
          final candidate = data['id'] ?? data['admin_id'] ?? data['id_administrador'] ?? data['usuario_id'] ?? data['user_id'];
          if (candidate != null) return candidate.toString();
        }
        return null;
      }

      final candidates = [
        responseBody['administrador' ],
        responseBody['admin'],
        responseBody['user'],
        responseBody['usuario'],
        responseBody['data'],
        responseBody['tecnico' ]
      ];

      for (final c in candidates) {
        final found = tryExtractId(c);
        if (found != null) {
          adminId = found;
          break;
        }
      }

      if (adminId == null) {
        final fallback = responseBody['id'] ?? responseBody['admin_id'] ?? responseBody['id_administrador'];
        adminId = tryExtractId(fallback);
      }

      if (adminId != null && adminId.isNotEmpty) {
        await storage.saveAdminId(adminId);
      }

      // Retornar el modelo de respuesta
      return loginResponseJson(response.body);
    } else {
      throw Exception('Error al iniciar sesión: ${response.statusCode}');
    }
  }
}
