
import 'dart:convert';
import 'package:flutter_a_c_soluciones/repository/client/solicitud_api_solicitud.dart';
import 'package:flutter_a_c_soluciones/repository/task_repository.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../model/administrador/visits_model.dart';
import '../model/ficha_model.dart';
import 'secure_storage_service.dart';

class VisitWithReport {
  final VisitsModel visit;
  final String pdfPath;

  VisitWithReport({required this.visit, required this.pdfPath});
}

class ReportRepository {
  final _storageService = SecureStorageService();
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<void> createMaintenanceSheet({
    required int visitId,
    required String introduccion,
    required String detallesServicio,
    required String observaciones,
    required String estadoAntes,
    required String descripcionTrabajo,
    required String materialesUtilizados,
    required String estadoFinal,
    required String tiempoDeTrabajo,
    required String recomendaciones,
    required String fechaDeMantenimiento,
    XFile? fotoEstadoAntes,
    XFile? fotoEstadoFinal,
    XFile? fotoDescripcionTrabajo,
  }) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    
    final taskRepository = TaskRepository();
    final solicitudRepository = SolicitudApiRepository();

    final visit = await taskRepository.getTaskById(visitId);
    final tecnicoId = visit.tecnicoId;
    final solicitudId = visit.solicitudId;

    final solicitud = await solicitudRepository.getSolicitudById(solicitudId);
    final clienteId = solicitud.clienteId;

    if (clienteId == null) {
      throw Exception('Could not find client ID for this visit.');
    }

    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/fichas'));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['id_cliente'] = clienteId.toString();
    request.fields['id_tecnico'] = tecnicoId.toString();
    request.fields['id_visitas'] = visitId.toString();
    request.fields['introduccion'] = introduccion;
    request.fields['detalles_servicio'] = detallesServicio;
    request.fields['observaciones'] = observaciones;
    request.fields['estado_antes'] = estadoAntes;
    request.fields['descripcion_trabajo'] = descripcionTrabajo;
    request.fields['materiales_utilizados'] = materialesUtilizados;
    request.fields['estado_final'] = estadoFinal;
    request.fields['tiempo_de_trabajo'] = tiempoDeTrabajo;
    request.fields['recomendaciones'] = recomendaciones;
    request.fields['fecha_de_mantenimiento'] = fechaDeMantenimiento;

    if (fotoEstadoAntes != null) {
      request.files.add(await http.MultipartFile.fromPath('foto_estado_antes', fotoEstadoAntes.path));
    }
    if (fotoEstadoFinal != null) {
      request.files.add(await http.MultipartFile.fromPath('foto_estado_final', fotoEstadoFinal.path));
    }
    if (fotoDescripcionTrabajo != null) {
      request.files.add(await http.MultipartFile.fromPath('foto_descripcion_trabajo', fotoDescripcionTrabajo.path));
    }

    final response = await request.send();

    if (response.statusCode != 201 && response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Error al crear el reporte: $responseBody');
    }
  }

  Future<String?> getPdfPathForVisit(int visitId) async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/fichas?id_visitas=$visitId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final ficha = FichaModel.fromJson(data[0] as Map<String, dynamic>);
        return ficha.pdfPath;
      }
      return null;
    } else {
      throw Exception('Failed to load PDF path');
    }
  }

  Future<List<VisitWithReport>> getVisitsWithReports() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final technicalId = decodedToken['id'];
    if (technicalId == null) {
      throw Exception('Technical ID not found in token');
    }

    // 1. Fetch all fichas (reports)
    final fichaResponse = await http.get(
      Uri.parse('$_baseUrl/fichas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (fichaResponse.statusCode != 200) {
      throw Exception('Failed to load fichas');
    }

    final List<dynamic> fichaListJson = json.decode(fichaResponse.body) as List<dynamic>? ?? [];
    final List<FichaModel> allFichas = fichaListJson
        .map((item) => FichaModel.fromJson(item as Map<String, dynamic>))
        .toList();

    // 2. Filter reports by the current technician's ID
    final technicianFichas = allFichas.where((ficha) => ficha.tecnicoId == technicalId).toList();

    // 3. For each report, fetch its corresponding visit details
    final List<VisitWithReport> visitsWithReports = [];
    for (var ficha in technicianFichas) {
      try {
        final visitId = ficha.visitId;
        final visitResponse = await http.get(
          Uri.parse('$_baseUrl/visitas/$visitId'), // Assuming this endpoint exists
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (visitResponse.statusCode == 200) {
          final visitJson = json.decode(visitResponse.body);
          final visitData = visitJson.containsKey('data') ? visitJson['data'] : visitJson;
          final visit = VisitsModel.fromJson(visitData as Map<String, dynamic>);
          
          visitsWithReports.add(VisitWithReport(
            visit: visit,
            pdfPath: ficha.pdfPath,
          ));
        }
      } catch (e) {
        // Silenciado intencionalmente
      }
    }
    
    return visitsWithReports;
  }
}
