import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

import '../../../bloc/report/report_bloc.dart';
import '../../../repository/report_repository.dart';
import '../../../repository/secure_storage_service.dart';

class ViewReportListPageTc extends StatelessWidget {
  const ViewReportListPageTc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc(ReportRepository())..add(FetchReports()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Reportes', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
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
      // 1. Check and request permission
      var storageStatus = await Permission.storage.request();

      var mediaStatus = await Permission.accessMediaLocation.request();

      if (!storageStatus.isGranted && !mediaStatus.isGranted) {
        if (storageStatus.isPermanentlyDenied || mediaStatus.isPermanentlyDenied) {
          // Show a dialog to open app settings
          if (!mounted) return;
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
          return; // Stop further execution
        }

        // Show a snackbar explaining why the permission is needed
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'El permiso de almacenamiento es necesario para descargar reportes.'),
          ),
        );
        return; // Stop further execution
      }

      // 2. Get the downloads directory
      final Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception('No se pudo encontrar el directorio de descargas.');
      }
      
      // Extract filename from the path
      final String fileName = fullPdfPath.split(r'\').last;
      final String savePath = '${downloadsDir.path}/$fileName';

      // 3. Download the file
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
        // 4. Save the file
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

        // 5. Open the file
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
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReportError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is ReportLoaded) {
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
                  const String apiKey = 'http://10.0.2.2:8000';
                  String relativePath = report.pdfPath.replaceFirst(RegExp(r'uploads[\\/]'), '');
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
    final visit = report.visit;
    final formattedDate =
        DateFormat('dd/MM/yyyy').format(visit.fechaProgramada);

    return Card(
      elevation: 6,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            const Icon(Icons.article, size: 35, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visita: ${visit.notasPrevias.isNotEmpty ? visit.notasPrevias : "Sin notas previas"}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Notas post-visita: ${visit.notasPosteriores.isNotEmpty ? visit.notasPosteriores : "N/A"}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text("Fecha: $formattedDate",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : IconButton(
                    icon: const Icon(Icons.download_for_offline,
                        color: Colors.green),
                    tooltip: 'Descargar Reporte',
                    onPressed: onDownload,
                  ),
          ],
        ),
      ),
    );
  }
}