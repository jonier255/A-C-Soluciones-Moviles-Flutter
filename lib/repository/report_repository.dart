
import 'dart:convert';
import 'package:http/http.dart' as http;
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
