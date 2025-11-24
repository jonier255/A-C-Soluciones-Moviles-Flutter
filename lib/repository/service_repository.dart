import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/servicio_model.dart';
import 'secure_storage_service.dart';

// Clase auxiliar para manejar respuesta con paginación
class ServicePageResponse {
  final List<Servicio> services;
  final bool hasMorePages;
  final int totalPages;

  ServicePageResponse({
    required this.services,
    required this.hasMorePages,
    required this.totalPages,
  });
}

class ServiceRepository {
  final _storageService = SecureStorageService();
  static const int pageSize = 10;  // Cuántos servicios traer por página
  static List<Servicio>? _cachedServices;  // Cache de todos los servicios

  /// Obtiene servicios con paginación en memoria
  /// [page] - Número de página (empieza en 1)
  /// Retorna ServicePageResponse con la lista de servicios y si hay más páginas
  Future<ServicePageResponse> getServices({int page = 1}) async {
    // Si no hay cache, obtener todos los servicios del servidor
    if (_cachedServices == null) {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception(
            'Token no encontrado. Por favor, inicie sesión de nuevo.');
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/servicios'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        List<Servicio> services = [];

        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          final List<dynamic> list = decoded['data'] as List<dynamic>;
          services = list
              .map((item) => Servicio.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (decoded is List) {
          services = decoded
              .map((item) => Servicio.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Estructura de respuesta inesperada');
        }

        _cachedServices = services;
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Por favor, inicie sesión de nuevo.');
      } else {
        throw Exception('Fallo en la solicitud (status: ${response.statusCode})');
      }
    }

    // Implementar paginación en memoria
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    
    final paginatedServices = _cachedServices!.skip(startIndex).take(pageSize).toList();
    final hasMorePages = endIndex < _cachedServices!.length;
    final totalPages = (_cachedServices!.length / pageSize).ceil();

    return ServicePageResponse(
      services: paginatedServices,
      hasMorePages: hasMorePages,
      totalPages: totalPages,
    );
  }
  
  /// Limpia el cache de servicios
  void clearCache() {
    _cachedServices = null;
  }
}
