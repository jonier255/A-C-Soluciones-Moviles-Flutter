import 'dart:convert';
import 'package:flutter_a_c_soluciones/model/administrador/visits_model.dart';
import 'package:http/http.dart' as http;
import '../model/technical/task_model.dart';
import 'secure_storage_service.dart';

class TaskRepository {
  final _storageService = SecureStorageService();
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<VisitsModel> getTaskById(int taskId) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token no encontrado.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/visitas/$taskId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded is Map<String, dynamic> && decoded.containsKey('data') ? decoded['data'] : decoded;
      return VisitsModel.fromJson(data);
    } else {
      throw Exception('Fallo al cargar la tarea (status: ${response.statusCode})');
    }
  }

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
      Uri.parse('http://10.0.2.2:8000/api/visitas/asignados/'),
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
