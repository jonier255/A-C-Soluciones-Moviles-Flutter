import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/technical/task_model.dart';
import 'secure_storage_service.dart';

class TaskRepository {
  final _storageService = SecureStorageService();
  final String _baseUrl = 'https://flutter-58c3.onrender.com/api';

  Future<void> updateTaskState(int taskId, String state) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token no encontrado. Por favor, inicie sesión de nuevo.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/visitas/$taskId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'estado': state}),
    );

    if (response.statusCode != 200) {
      throw Exception('Fallo en la actualización del estado (status: ${response.statusCode})');
    }
  }

  Future<List<TaskModel>> getTasks() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception(
          'Token no encontrado. Por favor, inicie sesión de nuevo.');
    }

    final response = await http.get(
      Uri.parse('https://flutter-58c3.onrender.com/api/visitas/asignados/'),
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
            .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
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
