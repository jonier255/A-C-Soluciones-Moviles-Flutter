import 'dart:convert';
import 'package:flutter_a_c_soluciones/model/administrador/admin_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';

class AdminUpdateProfileRepository {
  final String _baseUrl = "https://flutter-58c3.onrender.com/api"; 

  Future<UpdateAdminRequest> getAdminProfile() async {
    final storage = SecureStorageService();
    final token = await storage.getToken();
    final adminId = await storage.getAdminId();

    if (token == null || adminId == null) {
      throw Exception('Token o ID de administrador no encontrados');
    }

    // Use the configured baseUrl and the stored adminId in the endpoint
    final url = '$_baseUrl/admin/$adminId';
    // production: no debug prints

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // Backend may return the admin inside a wrapper, try common keys
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
      // include response body for easier debugging
      throw Exception('Error al actualizar el perfil: HTTP ${response.statusCode} - ${response.body}');
    }
  }
}
