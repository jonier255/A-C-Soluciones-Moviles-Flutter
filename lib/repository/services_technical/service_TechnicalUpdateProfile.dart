import 'dart:convert';
import 'package:flutter_a_c_soluciones/model/technical/technical_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';

class TechnicalUpdateProfileRepository {
  final String _baseUrl = "https://flutter-58c3.onrender.com/api"; 

  Future<UpdateTechnicalRequest> getTechnicalProfile() async {
    final storage = SecureStorageService();
    final token = await storage.getToken();
    final technicalId = await storage.getTechnicalId();

    if (token == null || technicalId == null) {
      throw Exception('Token o ID de técnico no encontrados');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/tecnico/$technicalId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UpdateTechnicalRequest.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el perfil: ${response.body}');
    }
  }

  Future<void> updateTechnicalProfile(UpdateTechnicalRequest data) async {
    final storage = SecureStorageService();
    final token = await storage.getToken();
    final technicalId = await storage.getTechnicalId();

    if (token == null || technicalId == null) {
      throw Exception('Token o ID de técnico no encontrados');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/tecnico/$technicalId'), 
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
