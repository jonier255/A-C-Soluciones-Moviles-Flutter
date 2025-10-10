import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/client/service_model.dart';
import '../secure_storage_service.dart';

class ServiceRepository {
  final _storageService = SecureStorageService();

  Future<List<ServiceModel>> getServices() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception(
          'Token no encontrado. Por favor, inicie sesión de nuevo.');
    }

    final response = await http.get(
      Uri.parse('http://localhost:8000/api/servicios'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ServiceModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Failed to load services');
    }
  }
}
