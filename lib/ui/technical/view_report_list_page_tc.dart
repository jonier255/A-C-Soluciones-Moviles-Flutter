
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_plus/open_file_plus.dart';

import '../../../bloc/report/report_bloc.dart';
import '../../../repository/report_repository.dart';

class ViewReportListPageTc extends StatelessWidget {
  const ViewReportListPageTc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc(ReportRepository())..add(FetchReports()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Reportes'),
          backgroundColor: Colors.blue.shade800,
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
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Permiso de almacenamiento denegado.');
        }
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
      final response = await http.get(Uri.parse(url));

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
    } finally {
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
              final formattedDate =
                  DateFormat('dd/MM/yyyy').format(visit.fechaProgramada);
              const String baseUrl = 'http://10.0.2.2:8000/api';
              final String downloadUrl =
                  '$baseUrl/fichas/descargar/${visit.id}';

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  leading: Icon(Icons.article, color: Colors.blue.shade800),
                  title: Text(
                    'Visita: ${visit.notasPrevias.isNotEmpty ? visit.notasPrevias : "Sin notas previas"}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Fecha: $formattedDate\nNotas post-visita: ${visit.notasPosteriores.isNotEmpty ? visit.notasPosteriores : "N/A"}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: isLoading
                      ? const CircularProgressIndicator()
                      : IconButton(
                          icon: const Icon(Icons.download_for_offline,
                              color: Colors.green),
                          tooltip: 'Descargar Reporte',
                          onPressed: () {
                            _downloadAndOpenFile(
                                downloadUrl, report.pdfPath, visit.id);
                          },
                        ),
                  isThreeLine: true,
                ),
              );
            },
          );
        }
        return const Center(child: Text('Iniciando...'));
      },
    );
  }
}
