import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_a_c_soluciones/model/client/client_profile_model.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';

class ClientProfileRepository {
  final String _baseUrl = "https://flutter-58c3.onrender.com/api";

  Future<ClientProfileModel> getClientProfile() async {
    final storage = SecureStorageService();
    final token = await storage.getToken();

    if (token == null) {
      throw Exception('Token no encontrado. Por favor, inicie sesión de nuevo.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/mi-perfil'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ClientProfileModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Por favor, inicie sesión de nuevo.');
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['message'] ?? errorBody['error'] ?? 'Error al obtener el perfil';
      throw Exception(errorMessage);
    }
  }

  Future<void> updateClientProfile(ClientProfileModel data) async {
    final storage = SecureStorageService();
    final token = await storage.getToken();

    if (token == null) {
      throw Exception('Token no encontrado. Por favor, inicie sesión de nuevo.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/mi-perfil'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data.toJson(includePassword: data.contrasenia != null && data.contrasenia!.isNotEmpty)),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Por favor, inicie sesión de nuevo.');
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['message'] ?? errorBody['error'] ?? 'Error al actualizar el perfil';
      throw Exception(errorMessage);
    }
  }
}

