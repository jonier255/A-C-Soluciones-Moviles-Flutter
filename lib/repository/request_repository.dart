import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/request_model.dart';
import 'secure_storage_service.dart';

class RequestRepository {
  final _storageService = SecureStorageService();

  Future<List<Request>> getRequests() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token no encontrado. Por favor, inicie sesión de nuevo.');
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/solicitudes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Request.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Failed to load requests');
    }
  }
}