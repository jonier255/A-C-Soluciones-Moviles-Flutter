import 'dart:convert';
import 'package:flutter_a_c_soluciones/model/administrador/admin_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';

class AdminUpdateProfileRepository {
  final String _baseUrl = "http://10.0.2.2:8000/api"; 

  Future<UpdateAdminRequest> getAdminProfile() async {
    final storage = SecureStorageService();
    final token = await storage.getToken();
    final adminId = await storage.getAdminId();

    if (token == null || adminId == null) {
      throw Exception('Token o ID de administrador no encontrados');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/admin/$adminId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UpdateAdminRequest.fromJson(jsonDecode(response.body));
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

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el perfil: ${response.body}');
    }
  }
}
