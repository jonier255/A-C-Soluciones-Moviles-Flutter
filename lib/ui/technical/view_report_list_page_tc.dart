import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

class _ReportList extends StatelessWidget {
  const _ReportList();

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
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
              final formattedDate = DateFormat('dd/MM/yyyy').format(visit.fechaProgramada);
              const String baseUrl = 'http://10.0.2.2:8000/api';
              final String downloadUrl = '$baseUrl/fichas/descargar/${visit.id}';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  trailing: IconButton(
                    icon: const Icon(Icons.download_for_offline, color: Colors.green),
                    tooltip: 'Descargar Reporte',
                    onPressed: () {
                      _launchURL(downloadUrl);
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