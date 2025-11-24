import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

import 'package:flutter_a_c_soluciones/bloc/view_reports/view_reports_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';
import 'package:flutter_a_c_soluciones/ui/technical/widgets/bottom_nav_bar.dart';

class ViewReportListPageTc extends StatelessWidget {
  const ViewReportListPageTc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViewReportsBloc(reportRepository: ReportRepository())..add(LoadViewReports()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Reportes', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        bottomNavigationBar: const BottomNavBar(),
        body: const _ReportList(),
      ),
    );
  }
}

class _ReportList extends StatefulWidget {
  const _ReportList();

  @override
  State<_ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<_ReportList> {
  final Map<int, bool> _loadingStates = {};

  Future<void> _downloadAndOpenFile(
      String url, String fullPdfPath, int visitId) async {
    if (!mounted) return;
    setState(() {
      _loadingStates[visitId] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Iniciando descarga...')),
    );

    try {
      var storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
         if (storageStatus.isPermanentlyDenied) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Permiso Requerido'),
                content: const Text(
                    'El permiso de almacenamiento es necesario para descargar y guardar reportes. Por favor, habilite el permiso en la configuración de la aplicación.'),
                actions: [
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text('Abrir Configuración'),
                    onPressed: () {
                      openAppSettings();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
         } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'El permiso de almacenamiento es necesario para descargar reportes.'),
              ),
            );
         }
         return;
      }

      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory safeDir = Directory('${appDir.path}/reportes');
      if (!(await safeDir.exists())) {
        await safeDir.create(recursive: true);
      }

      final String fileName = fullPdfPath.split(RegExp(r'[\/]+')).last;
      final String savePath = '${safeDir.path}/$fileName';

      final _storageService = SecureStorageService();
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('Token no encontrado. Por favor, inicie sesión de nuevo.');
      }
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Descarga completa: $fileName'),
            action: SnackBarAction(
              label: 'ABRIR',
              onPressed: () {
                OpenFile.open(savePath);
              },
            ),
          ),
        );
        await OpenFile.open(savePath);
      } else {
        throw Exception('Error al descargar el archivo: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
    finally {
      if (mounted) {
        setState(() {
          _loadingStates[visitId] = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewReportsBloc, ViewReportsState>(
      builder: (context, state) {
        if (state is ViewReportsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ViewReportsFailure) {
          return Center(child: Text('Error: ${state.error}'));
        } else if (state is ViewReportsLoaded) {
          if (state.reports.isEmpty) {
            return const Center(child: Text('No hay reportes disponibles.'));
          }
          return ListView.builder(
            itemCount: state.reports.length,
            itemBuilder: (context, index) {
              final report = state.reports[index];
              final visit = report.visit;
              final bool isLoading = _loadingStates[visit.id] ?? false;

              return _ReportCard(
                report: report,
                isLoading: isLoading,
                onDownload: () {
                  const String apiKey = 'https://flutter-58c3.onrender.com';
                  String relativePath = report.pdfPath.replaceFirst(RegExp(r'uploads[\/]'), '');
                  relativePath = relativePath.replaceAll(r'\', '/');
                  final String downloadUrl = '$apiKey/$relativePath';
                  _downloadAndOpenFile(downloadUrl, report.pdfPath, visit.id);
                },
              );
            },
          );
        }
        return const Center(child: Text('Iniciando...'));
      },
    );
  }
}

class _ReportCard extends StatelessWidget {
  final dynamic report;
  final bool isLoading;
  final VoidCallback onDownload;

  const _ReportCard({
    required this.report,
    required this.isLoading,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final visit = report.visit;
    final formattedDate =
        DateFormat('dd/MM/yyyy').format(visit.fechaProgramada);

    return Card(
      elevation: 6,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.05)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.035),
        child: Row(
          children: [
            Icon(Icons.article, size: screenWidth * 0.09, color: Colors.black),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visita: ${visit.notasPrevias.isNotEmpty ? visit.notasPrevias : "Sin notas previas"}',
                    style: TextStyle(fontSize: screenWidth * 0.038, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    'Notas post-visita: ${visit.notasPosteriores.isNotEmpty ? visit.notasPosteriores : "N/A"}',
                    style: TextStyle(fontSize: screenWidth * 0.032, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text("Fecha: $formattedDate",
                      style:
                          TextStyle(fontSize: screenWidth * 0.032, color: Colors.grey)),
                ],
              ),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : IconButton(
                    icon: Icon(Icons.download_for_offline,
                        color: Colors.green, size: screenWidth * 0.07),
                    tooltip: 'Descargar Reporte',
                    onPressed: onDownload,
                  ),
          ],
        ),
      ),
    );
  }
}
