import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/visits_model.dart';
import 'secure_storage_service.dart';

class VisitsRepository {
  final _storageService = SecureStorageService();

  Future<List<VisitsModel>> getVisits() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token no encontrado. Por favor, inicie sesión de nuevo.');
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/visitas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {

      final decoded = json.decode(response.body);

      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        final List<dynamic> list = decoded['data'] as List<dynamic>;

        return list
            .map((item) => VisitsModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Estructura de respuesta inesperada');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo en la solicitud (status: ${response.statusCode})');
    }
  }
}
