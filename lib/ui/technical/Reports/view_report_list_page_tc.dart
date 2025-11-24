import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/view_reports/view_reports_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';
import 'package:flutter_a_c_soluciones/ui/technical/widgets/bottom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewReportListPageTc extends StatelessWidget {
  const ViewReportListPageTc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViewReportsBloc(reportRepository: ReportRepository())..add(LoadViewReports()),
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'Mis Reportes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
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
         } else {
            if (!mounted) return;
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
        } else if (state is ViewReportsLoaded || state is ViewReportsLoadingMore) {
          final reports = state is ViewReportsLoaded 
              ? state.reports 
              : (state as ViewReportsLoadingMore).currentReports;
          final currentPage = state is ViewReportsLoaded ? state.currentPage : 1;
          
          if (reports.isEmpty) {
            return const Center(child: Text('No hay reportes disponibles.'));
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                color: Colors.grey[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Página $currentPage',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${reports.length} reportes',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    final visit = report.visit;
                    final bool isLoading = _loadingStates[visit.id] ?? false;

                    return _ReportCard(
                      report: report,
                      isLoading: isLoading,
                      onDownload: () {
                        const String apiKey = 'http://10.0.2.2:8000';
                        String relativePath = report.pdfPath.replaceFirst(RegExp(r'uploads[\/]'), '');
                        relativePath = relativePath.replaceAll(r'\', '/');
                        final String downloadUrl = '$apiKey/$relativePath';
                        _downloadAndOpenFile(downloadUrl, report.pdfPath, visit.id);
                      },
                    );
                  },
                ),
              ),
              _PaginationWidget(
                currentPage: currentPage,
                totalPages: state is ViewReportsLoaded ? state.totalPages : 1,
                isLoading: state is ViewReportsLoadingMore,
                onPageChanged: (page) {
                  context.read<ViewReportsBloc>().add(LoadMoreViewReports(page));
                },
              ),
            ],
          );
        }
        return const Center(child: Text('Iniciando...'));
      },
    );
  }
}

class _PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final Function(int) onPageChanged;

  const _PaginationWidget({
    required this.currentPage,
    required this.totalPages,
    required this.isLoading,
    required this.onPageChanged,
  });

  List<int> _getPageNumbers() {
    List<int> pages = [];
    
    if (totalPages <= 5) {
      // Si hay 5 o menos páginas, mostrarlas todas
      for (int i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    } else if (currentPage <= 3) {
      // Estamos al inicio, mostrar primeras 5 páginas
      for (int i = 1; i <= 5; i++) {
        pages.add(i);
      }
      pages.add(-1); // ...
    } else if (currentPage >= totalPages - 2) {
      // Estamos cerca del final
      pages.add(1);
      pages.add(-1); // ...
      for (int i = totalPages - 4; i <= totalPages; i++) {
        if (i > 1) pages.add(i);
      }
    } else {
      // Estamos en el medio
      pages.add(1);
      pages.add(-1); // ...
      
      // Mostrar páginas alrededor de la actual
      for (int i = currentPage - 1; i <= currentPage + 1; i++) {
        pages.add(i);
      }
      
      pages.add(-1); // ...
    }
    
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pages = _getPageNumbers();
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón Inicio
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage > 1 && !isLoading
                ? () => onPageChanged(1)
                : null,
            icon: const Icon(Icons.first_page, size: 20),
            color: Colors.blue,
            disabledColor: Colors.grey,
            tooltip: 'Primera página',
          ),
          // Botón Anterior
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage > 1 && !isLoading
                ? () => onPageChanged(currentPage - 1)
                : null,
            icon: const Icon(Icons.chevron_left, size: 20),
            color: Colors.blue,
            disabledColor: Colors.grey,
            tooltip: 'Página anterior',
          ),
          const SizedBox(width: 4),
          
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            ...pages.map((page) {
              if (page == -1) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('...', style: TextStyle(fontSize: 18)),
                );
              }
              
              final isCurrentPage = page == currentPage;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: InkWell(
                  onTap: isCurrentPage || isLoading ? null : () => onPageChanged(page),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isCurrentPage ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isCurrentPage ? Colors.blue : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      page.toString(),
                      style: TextStyle(
                        color: isCurrentPage ? Colors.white : Colors.black87,
                        fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          
          const SizedBox(width: 4),
          // Botón Siguiente
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage < totalPages && !isLoading
                ? () => onPageChanged(currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right, size: 20),
            color: Colors.blue,
            disabledColor: Colors.grey,
            tooltip: 'Página siguiente',
          ),
          // Botón Final
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage < totalPages && !isLoading
                ? () => onPageChanged(totalPages)
                : null,
            icon: const Icon(Icons.last_page, size: 20),
            color: Colors.blue,
            disabledColor: Colors.grey,
            tooltip: 'Última página',
          ),
        ],
      ),
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
