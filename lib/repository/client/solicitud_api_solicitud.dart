import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/client/solicitud_model.dart';
import '../secure_storage_service.dart';

class SolicitudApiRepository {
  final _storageService = SecureStorageService();

  Future<List<Solicitud>> getSolicitudes() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception(
          'Token no encontrado. Por favor, inicie sesión de nuevo.');
    }

    final response = await http.get(
      Uri.parse('https://flutter-58c3.onrender.com/api/solicitudes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // 🔹 Si la API devuelve { "data": [...] }
      final List<dynamic> data = decoded is List ? decoded : decoded['data'];

      return data.map((json) => Solicitud.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception(
          'Error al cargar las solicitudes (${response.statusCode})');
    }
  }

  Future<Solicitud> getSolicitudById(int solicitudId) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await http.get(
      Uri.parse('https://flutter-58c3.onrender.com/api/solicitudes/$solicitudId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded is Map<String, dynamic> && decoded.containsKey('data') ? decoded['data'] : decoded;
      return Solicitud.fromJson(data);
    } else {
      throw Exception('Error al cargar la solicitud (${response.statusCode})');
    }
  }

  // POST para crear solicitud
  Future<Solicitud> crearSolicitud({
    required int clienteId,
    required int servicioId,
    required String direccion,
    required String descripcion,
    String comentarios = '',
    DateTime? fechaSolicitud,
  }) async {
    final token = await _storageService.getToken();
    if (token == null) throw Exception('Token no encontrado');

    final body = {
      'cliente_id_fk': clienteId,
      'servicio_id_fk': servicioId,
      'direccion_servicio': direccion,
      'descripcion': descripcion,
      'comentarios': comentarios,
      'fecha_solicitud': (fechaSolicitud ?? DateTime.now()).toIso8601String(),
    };

    final response = await http.post(
      Uri.parse('https://flutter-58c3.onrender.com/api/solicitudes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return Solicitud.fromJson(data);
    } else {
      throw Exception('Error al crear solicitud (${response.statusCode})');
    }
  }
}
