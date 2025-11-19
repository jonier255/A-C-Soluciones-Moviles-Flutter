import 'dart:convert';
// import 'package:flutter_a_c_soluciones/server/conexion.dart';
import 'package:http/http.dart' as http;
import '../../model/administrador/admin_model.dart';
import '../secure_storage_service.dart';

class AdminRepository {
  final _storageService = SecureStorageService();

  Future<List<UpdateAdminRequest>> getAdmins() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception(
          'Token no encontrado. Por favor, inicie sesión de nuevo.');
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/admin'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UpdateAdminRequest.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Failed to load Admins');
    }
  }
}
