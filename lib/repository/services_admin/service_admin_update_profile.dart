import 'dart:convert';

import 'package:flutter_a_c_soluciones/model/administrador/admin_model.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class AdminUpdateProfileRepository {
  final String _baseUrl = "http://10.0.2.2:8000/api"; 

  Future<UpdateAdminRequest> getAdminProfile() async {
    final storage = SecureStorageService();
    final token = await storage.getToken();
    final adminId = await storage.getAdminId();

    if (token == null || adminId == null) {
      throw Exception('Token o ID de administrador no encontrados');
    }

    final url = '$_baseUrl/admin/$adminId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      Map<String, dynamic> adminMap;
      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('administrador')) {
          adminMap = Map<String, dynamic>.from(decoded['administrador']);
        } else if (decoded.containsKey('data')) {
          adminMap = Map<String, dynamic>.from(decoded['data']);
        } else {
          adminMap = decoded;
        }
      } else {
        throw Exception('Respuesta inesperada del servidor: ${response.body}');
      }

      try {
        return UpdateAdminRequest.fromJson(adminMap);
      } catch (e) {
        throw Exception('Error parseando perfil de administrador: $e -- raw: ${response.body}');
      }
    } else {
      throw Exception('Error al obtener el perfil: ${response.body}');
    }
  }

  Future<void> updateAdminProfile(UpdateAdminRequest data) async {
    final storage = SecureStorageService();
    final token = await storage.getToken();
    final adminId = await storage.getAdminId();

    if (token == null || adminId == null) {
      throw Exception('Token o ID de administrador no encontrados');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/admin/$adminId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else {
      throw Exception('Error al actualizar el perfil: HTTP ${response.statusCode} - ${response.body}');
    }
  }
}
