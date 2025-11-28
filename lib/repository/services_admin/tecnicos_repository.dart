import 'dart:convert';

import 'package:flutter_a_c_soluciones/model/tecnico_model.dart';
import 'package:http/http.dart' as http;

// Clase auxiliar para manejar respuesta con paginación
class TecnicoPageResponse {
  final List<Tecnico> tecnicos;
  final bool hasMorePages;
  final int totalPages;

  TecnicoPageResponse({
    required this.tecnicos,
    required this.hasMorePages,
    required this.totalPages,
  });
}

class TecnicosRepository {
  static const int pageSize = 10;
  static List<Tecnico>? _cachedTecnicos;

  /// Obtiene técnicos con paginación en memoria
  Future<TecnicoPageResponse> getTecnicos({int page = 1}) async {
    // Si no hay cache, obtener todos los técnicos del servidor
    if (_cachedTecnicos == null) {
      final url = Uri.parse('https://flutter-58c3.onrender.com/api/tecnico');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _cachedTecnicos = data.map((json) => Tecnico.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tecnicos');
      }
    }

    // Paginar en memoria
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    
    final paginatedTecnicos = _cachedTecnicos!.sublist(
      startIndex,
      endIndex > _cachedTecnicos!.length ? _cachedTecnicos!.length : endIndex,
    );

    final hasMorePages = endIndex < _cachedTecnicos!.length;
    final totalPages = (_cachedTecnicos!.length / pageSize).ceil();

    return TecnicoPageResponse(
      tecnicos: paginatedTecnicos,
      hasMorePages: hasMorePages,
      totalPages: totalPages,
    );
  }

  /// Limpia el cache de técnicos
  void clearCache() {
    _cachedTecnicos = null;
  }
}
