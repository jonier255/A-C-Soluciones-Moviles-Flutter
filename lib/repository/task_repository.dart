import 'dart:convert';
import 'package:flutter_a_c_soluciones/model/administrador/visits_model.dart';
import 'package:http/http.dart' as http;
import '../model/technical/task_model.dart';
import 'secure_storage_service.dart';

class TaskRepository {
  final _storageService = SecureStorageService();
  final String _baseUrl = 'https://flutter-58c3.onrender.com/api';

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
    
    // Limpiar cache para forzar recarga de datos
    clearCache();
  }

  static const int pageSize = 10;
  static List<TaskModel>? _cachedTasks;

  Future<TaskResponse> getTasks({int page = 1}) async {
    // Si no hay cache, obtener todas las tareas del servidor
    if (_cachedTasks == null) {
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

          _cachedTasks = list
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

    // Implementar paginación en memoria
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    
    final paginatedTasks = _cachedTasks!.skip(startIndex).take(pageSize).toList();
    final hasMorePages = endIndex < _cachedTasks!.length;
    final totalPages = (_cachedTasks!.length / pageSize).ceil();

    return TaskResponse(tasks: paginatedTasks, hasMorePages: hasMorePages, totalPages: totalPages);
  }
  
  void clearCache() {
    _cachedTasks = null;
  }
}

class TaskResponse {
  final List<TaskModel> tasks;
  final bool hasMorePages;
  final int totalPages;
  
  TaskResponse({required this.tasks, required this.hasMorePages, required this.totalPages});
}
