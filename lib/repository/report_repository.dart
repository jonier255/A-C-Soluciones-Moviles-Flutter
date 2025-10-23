
import 'dart:convert';
import 'package:flutter/foundation.dart';
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
  final String _baseUrl = 'http://10.0.2.2:8000/api';

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
    print('[Repository] Starting getVisitsWithReports...');
    final token = await _storageService.getToken();
    if (token == null) {
      print('[Repository] Error: Token not found.');
      throw Exception('Token not found');
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    if (kDebugMode) {
      print('[Repository] Decoded Token: $decodedToken');
    }
    final technicalId = decodedToken['id'];
    if (technicalId == null) {
      print('[Repository] Error: Technical ID not found in token.');
      throw Exception('Technical ID not found in token');
    }
    print('[Repository] Technician ID: $technicalId');

    // 1. Fetch all fichas (reports)
    print('[Repository] Fetching all reports from /fichas...');
    final fichaResponse = await http.get(
      Uri.parse('$_baseUrl/fichas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (fichaResponse.statusCode != 200) {
      print('[Repository] Error: Failed to load fichas. Status: ${fichaResponse.statusCode}');
      throw Exception('Failed to load fichas');
    }

    final List<dynamic> fichaListJson = json.decode(fichaResponse.body) as List<dynamic>? ?? [];
    final List<FichaModel> allFichas = fichaListJson
        .map((item) => FichaModel.fromJson(item as Map<String, dynamic>))
        .toList();
    print('[Repository] Found a total of ${allFichas.length} reports.');

    // 2. Filter reports by the current technician's ID
    final technicianFichas = allFichas.where((ficha) => ficha.tecnicoId == technicalId).toList();
    print('[Repository] Found ${technicianFichas.length} reports specifically for technician ID $technicalId');

    // 3. For each report, fetch its corresponding visit details
    final List<VisitWithReport> visitsWithReports = [];
    print('[Repository] Fetching visit details for each of the ${technicianFichas.length} reports...');
    for (var ficha in technicianFichas) {
      try {
        final visitId = ficha.visitId;
        print('[Repository]   - Fetching visit ID: $visitId for report ID: ${ficha.id}');
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
          print('[Repository]   - Successfully fetched and added visit ID: $visitId');
        } else {
          print('[Repository]   - Failed to fetch visit details for visit ID: $visitId. Status: ${visitResponse.statusCode}');
        }
      } catch (e) {
        print('[Repository]   - Error processing report ${ficha.id}: $e');
      }
    }
    
    print('[Repository] Finished. Successfully constructed ${visitsWithReports.length} VisitWithReport objects.');
    return visitsWithReports;
  }
}
