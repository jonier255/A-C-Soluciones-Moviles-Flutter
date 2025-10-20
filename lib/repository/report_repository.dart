
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../model/visits_model.dart';
import '../model/ficha_model.dart';
import 'secure_storage_service.dart';

class VisitWithReport {
  final VisitsModel visit;
  final String pdfPath;

  VisitWithReport({required this.visit, required this.pdfPath});
}

class ReportRepository {
  final _storageService = SecureStorageService();
  final String _baseUrl = 'https://a-c-soluciones.onrender.com/api';

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

    final visitResponse = await http.get(
      Uri.parse('$_baseUrl/visitas/asignados/$technicalId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (visitResponse.statusCode != 200) {
      throw Exception('Failed to load assigned visits');
    }

    final visitDecoded = json.decode(visitResponse.body);
    final dynamic visitData = visitDecoded['data'];
    List<dynamic> visitListJson = [];
    if (visitData is List) {
      visitListJson = visitData;
    } else if (visitData is Map<String, dynamic>) {
      visitListJson = [visitData];
    }

    final List<VisitsModel> assignedVisits = visitListJson
        .map((item) => VisitsModel.fromJson(item as Map<String, dynamic>))
        .toList();

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

    final reportMap = {for (var ficha in allFichas) ficha.visitId.toString(): ficha.pdfPath};

    final List<VisitWithReport> visitsWithReports = assignedVisits
        .where((visit) => reportMap.containsKey(visit.id.toString()))
        .map((visit) => VisitWithReport(
              visit: visit,
              pdfPath: reportMap[visit.id.toString()]!,
            ))
        .toList();

    return visitsWithReports;
  }
}
