import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';
import 'package:flutter_a_c_soluciones/repository/task_repository.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Reports/report_screen.dart';
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
      setState(() {
        _pdfPath = pdfPath;
        _isLoading = false;
      });
    } catch (e) {
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
      setState(() {
        _visitState = newState;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estado actualizado con éxito')),
      );
    } catch (e) {
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
      final url = 'http://10.0.2.2:8000/fichas/$fileName';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir el PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Container(
                  width: screenWidth * 0.9,
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.35),
                        blurRadius: 15,
                        spreadRadius: 3,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descripción',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.task.servicio.descripcion,
                          style: const TextStyle(fontSize: 17)),
                      const SizedBox(height: 28),
                      const Text(
                        'Información',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                          'Notas previas:', widget.task.notasPrevias ?? ''),
                      const SizedBox(height: 10),
                      _buildDetailRow('Notas posteriores:',
                          widget.task.notasPosteriores ?? ''),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                          'Fecha programada:',
                          widget.task.fechaProgramada
                              .toString()
                              .substring(0, 10)),
                      const SizedBox(height: 10),
                      _buildDetailRow('Duración estimada:',
                          '${widget.task.duracionEstimada} minutos'),
                      const SizedBox(height: 25),
                      _buildStateDropdown(),
                      const SizedBox(height: 25),
                      Center(
                        child: ElevatedButton(
                          onPressed: _pdfPath != null
                              ? _openPdf
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportScreen(
                                          visitId: widget.task.id),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                              _pdfPath != null
                                  ? 'Ver reporte'
                                  : 'Generar reporte',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStateDropdown() {
    return DropdownButtonFormField<String>(
      value: _visitState,
      decoration: const InputDecoration(
        labelText: 'Estado',
        labelStyle: TextStyle(fontSize: 17),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      items: ['programada', 'en_camino', 'iniciada', 'completada', 'cancelada']
          .map((label) => DropdownMenuItem(
                value: label,
                child: Text(label, style: const TextStyle(fontSize: 17)),
              ))
          .toList(),
      onChanged: ['completada', 'cancelada'].contains(_visitState)
          ? null
          : _handleStateChange,
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black87)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 6, top: 3),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.lightBlueAccent, width: 1.2),
              ),
            ),
            child: Text(
              value.isNotEmpty ? value : '—',
              style: const TextStyle(fontSize: 16.5, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
