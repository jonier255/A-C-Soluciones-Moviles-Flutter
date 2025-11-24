import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';
import 'package:flutter_a_c_soluciones/repository/task_repository.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Reports/create_report_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:flutter_a_c_soluciones/ui/technical/widgets/bottom_nav_bar.dart';

class VisitsDetailsScreen extends StatefulWidget {
  final TaskModel task;

  const VisitsDetailsScreen({super.key, required this.task});

  @override
  State<VisitsDetailsScreen> createState() => _VisitsDetailsScreenState();
}

class _VisitsDetailsScreenState extends State<VisitsDetailsScreen> {
  late String _visitState;
  String? _pdfPath;
  bool _isLoading = true;

  final ReportRepository _reportRepository = ReportRepository();
  final TaskRepository _taskRepository = TaskRepository();

  @override
  void initState() {
    super.initState();
    _visitState = widget.task.estado;
    _fetchPdfPath();
  }

  Future<void> _fetchPdfPath() async {
    try {
      final pdfPath = await _reportRepository.getPdfPathForVisit(widget.task.id);
      if (!mounted) return;
      setState(() {
        _pdfPath = pdfPath;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar reporte: $e')),
      );
    }
  }

  void _handleStateChange(String? newState) {
    if (newState == null) return;
    if (['completada', 'cancelada'].contains(newState)) {
      _showConfirmationDialog(newState);
    } else {
      _updateState(newState);
    }
  }

  Future<void> _updateState(String newState) async {
    try {
      await _taskRepository.updateTaskState(widget.task.id, newState);
      if (!mounted) return;
      setState(() {
        _visitState = newState;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estado actualizado con éxito')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el estado: $e')),
      );
    }
  }

  void _showConfirmationDialog(String newState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar cambio de estado'),
        content: Text(
            '¿Estás seguro de que deseas marcar esta visita como $newState? Esta acción podría ser irreversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateState(newState);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> _openPdf() async {
    if (_pdfPath == null) return;
    try {
      final pathFromServer = _pdfPath!.replaceAll(r'\', '/');
      final fileName = pathFromServer.split('/').last;
      final url = 'https://flutter-58c3.onrender.com/fichas/$fileName';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/report.pdf');
        await file.writeAsBytes(response.bodyBytes);
        OpenFile.open(file.path);
      } else {
        throw Exception('No se pudo descargar el PDF');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir el PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Visita'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Center(
                child: Container(
                  width: screenWidth * 0.9,
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.045),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.blue,
                        blurRadius: 15,
                        spreadRadius: 3,
                        offset: Offset(0, 5),
                      ),
                    ],
                    border: const Border(
                      top: BorderSide(color: Colors.blueAccent, width: 1.5),
                      left: BorderSide(color: Colors.blueAccent, width: 1.5),
                      right: BorderSide(color: Colors.blueAccent, width: 1.5),
                      bottom: BorderSide(color: Colors.blueAccent, width: 1.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Descripción',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05,
                            color: Colors.black87),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(widget.task.servicio.descripcion,
                          style: TextStyle(fontSize: screenWidth * 0.042)),
                      SizedBox(height: screenHeight * 0.035),
                      Text(
                        'Información',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05,
                            color: Colors.black87),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildDetailRow(
                          'Notas previas:', widget.task.notasPrevias ?? '', screenWidth, screenHeight),
                      SizedBox(height: screenHeight * 0.012),
                      _buildDetailRow('Notas posteriores:',
                          widget.task.notasPosteriores ?? '', screenWidth, screenHeight),
                      SizedBox(height: screenHeight * 0.012),
                      _buildDetailRow(
                          'Fecha programada:',
                          widget.task.fechaProgramada
                              .toString()
                              .substring(0, 10), screenWidth, screenHeight),
                      SizedBox(height: screenHeight * 0.012),
                      _buildDetailRow('Duración estimada:',
                          '${widget.task.duracionEstimada} minutos', screenWidth, screenHeight),
                      SizedBox(height: screenHeight * 0.03),
                      _buildStateDropdown(screenWidth, screenHeight),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: ElevatedButton(
                          onPressed: _pdfPath != null
                              ? _openPdf
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateReportScreen(
                                          visitId: widget.task.id),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.075, vertical: screenHeight * 0.017),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth * 0.02),
                            ),
                          ),
                          child: Text(
                              _pdfPath != null
                                  ? 'Ver reporte'
                                  : 'Generar reporte',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.042, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStateDropdown(double screenWidth, double screenHeight) {
    return DropdownButtonFormField<String>(
      value: _visitState,
      decoration: InputDecoration(
        labelText: 'Estado',
        labelStyle: TextStyle(fontSize: screenWidth * 0.042),
        border: const OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035, vertical: screenHeight * 0.015),
      ),
      items: ['programada', 'en_camino', 'iniciada', 'completada', 'cancelada']
          .map((label) => DropdownMenuItem(
                value: label,
                child: Text(label, style: TextStyle(fontSize: screenWidth * 0.042)),
              ))
          .toList(),
      onChanged: ['completada', 'cancelada'].contains(_visitState)
          ? null
          : _handleStateChange,
    );
  }

  Widget _buildDetailRow(String title, String value, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.042,
                  color: Colors.black87)),
          SizedBox(height: screenHeight * 0.005),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: screenHeight * 0.008, top: screenHeight * 0.004),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.lightBlueAccent, width: 1.2),
              ),
            ),
            child: Text(
              value.isNotEmpty ? value : '—',
              style: TextStyle(fontSize: screenWidth * 0.038, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
