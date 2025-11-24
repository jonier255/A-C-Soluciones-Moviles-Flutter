
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
  final String _baseUrl = 'https://flutter-58c3.onrender.com/api';

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
    print('🟢 [Repository] Iniciando createMaintenanceSheet para visitId: $visitId');
    
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    
    print('🟢 [Repository] Token obtenido');
    
    final taskRepository = TaskRepository();
    final solicitudRepository = SolicitudApiRepository();

    print('🟢 [Repository] Obteniendo datos de la visita...');
    final visit = await taskRepository.getTaskById(visitId);
    final tecnicoId = visit.tecnicoId;
    final solicitudId = visit.solicitudId;

    print('🟢 [Repository] Obteniendo datos de la solicitud...');
    final solicitud = await solicitudRepository.getSolicitudById(solicitudId);
    final clienteId = solicitud.clienteId;

    if (clienteId == null) {
      throw Exception('Could not find client ID for this visit.');
    }

    print('🟢 [Repository] Preparando request multipart...');
    print('🟢 [Repository] clienteId: $clienteId, tecnicoId: $tecnicoId, visitId: $visitId');
    
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
      print('🟢 [Repository] Agregando foto estado antes...');
      request.files.add(await http.MultipartFile.fromPath('foto_estado_antes', fotoEstadoAntes.path));
    }
    if (fotoEstadoFinal != null) {
      print('🟢 [Repository] Agregando foto estado final...');
      request.files.add(await http.MultipartFile.fromPath('foto_estado_final', fotoEstadoFinal.path));
    }
    if (fotoDescripcionTrabajo != null) {
      print('🟢 [Repository] Agregando foto descripción trabajo...');
      request.files.add(await http.MultipartFile.fromPath('foto_descripcion_trabajo', fotoDescripcionTrabajo.path));
    }

    print('🟢 [Repository] Enviando request al servidor...');
    final streamedResponse = await request.send();
    print('🟢 [Repository] Response recibida. Status: ${streamedResponse.statusCode}');
    
    print('🟢 [Repository] Convirtiendo stream a Response...');
    final response = await http.Response.fromStream(streamedResponse);
    print('🟢 [Repository] Response convertida. Body length: ${response.body.length}');

    if (response.statusCode != 201 && response.statusCode != 200) {
      print('❌ [Repository] Error en respuesta: ${response.statusCode}');
      
      // El backend tiene un bug: guarda el reporte pero devuelve 500
      // Verificamos si el reporte realmente se creó esperando un poco y consultando
      print('🟡 [Repository] Verificando si el reporte se creó a pesar del error...');
      await Future.delayed(const Duration(seconds: 2));
      
      try {
        final pdfPath = await getPdfPathForVisit(visitId);
        if (pdfPath != null) {
          print('✅ [Repository] Reporte encontrado a pesar del error 500! El backend lo guardó correctamente.');
          return; // El reporte existe, consideramos esto un éxito
        }
      } catch (e) {
        print('🟡 [Repository] No se pudo verificar el reporte: $e');
      }
      
      throw Exception('Error al crear el reporte: ${response.body}');
    }
    
    print('✅ [Repository] Reporte creado exitosamente!');
    return;
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
