import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/servicio_model.dart';
import 'secure_storage_service.dart';

// Clase auxiliar para manejar respuesta con paginación
class ServicePageResponse {
  final List<Servicio> services;
  final bool hasMorePages;

  ServicePageResponse({
    required this.services,
    required this.hasMorePages,
  });
}

class ServiceRepository {
  final _storageService = SecureStorageService();
  static const int pageSize = 10;  // Cuántos servicios traer por página

  /// Obtiene servicios con paginación
  /// [page] - Número de página (empieza en 1)
  /// Retorna ServicePageResponse con la lista de servicios y si hay más páginas
  Future<ServicePageResponse> getServices({int page = 1}) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception(
          'Token no encontrado. Por favor, inicie sesión de nuevo.');
    }

    // Agregar parámetros de paginación a la URL
    final uri = Uri.parse('http://10.0.2.2:8000/api/servicios')
        .replace(queryParameters: {
      'page': page.toString(),
      'limit': pageSize.toString(),
    });

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      List<Servicio> services = [];
      bool hasMorePages = false;

      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        final List<dynamic> list = decoded['data'] as List<dynamic>;
        services = list
            .map((item) => Servicio.fromJson(item as Map<String, dynamic>))
            .toList();
        
        // Verificar si hay más páginas (si retorna el pageSize completo, probablemente hay más)
        hasMorePages = services.length >= pageSize;
        
        // Si el servidor provee información de total/páginas, usarla aquí
        if (decoded.containsKey('hasMore')) {
          hasMorePages = decoded['hasMore'] as bool;
        }
      } else if (decoded is List) {
        services = decoded
            .map((item) => Servicio.fromJson(item as Map<String, dynamic>))
            .toList();
        hasMorePages = services.length >= pageSize;
      } else {
        throw Exception('Estructura de respuesta inesperada');
      }

      return ServicePageResponse(
        services: services,
        hasMorePages: hasMorePages,
      );
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Fallo en la solicitud (status: ${response.statusCode})');
    }
  }
}
