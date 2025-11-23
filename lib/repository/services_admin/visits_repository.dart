import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_a_c_soluciones/model/administrador/visits_model.dart';
import '../secure_storage_service.dart';

class VisitsRepository {
  final _storageService = SecureStorageService();

  Future<void> assignVisit(VisitsModel visit) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token no encontrado. Por favor, inicie sesión de nuevo.');
    }

    final url = Uri.parse('http://10.0.2.2:8000/api/visitas');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fecha_programada': visit.fechaProgramada.toIso8601String(),
        'duracion_estimada': visit.duracionEstimada,
        'notas_previas': visit.notasPrevias,
        'solicitud_id_fk': visit.solicitudId,
        'tecnico_id_fk': visit.tecnicoId,
        'servicio_id_fk': visit.servicioId,
      }),
    );

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Por favor, inicie sesión de nuevo.');
    } else {
      throw Exception('Failed to assign visit (status: ${response.statusCode})');
    }
  }
}
