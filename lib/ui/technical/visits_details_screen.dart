import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';
import 'package:flutter_a_c_soluciones/repository/task_repository.dart';
import 'package:flutter_a_c_soluciones/ui/technical/report_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

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
        content: Text('¿Estás seguro de que deseas marcar esta visita como $newState? Esta acción podría ser irreversible.'),
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
      final url = 'http://10.0.2.2:8000/$_pdfPath';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.servicio.nombre),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detalles de la Visita',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow('Servicio:', widget.task.servicio.nombre),
                  _buildDetailRow('Descripción:', widget.task.servicio.descripcion),
                  _buildDetailRow('Fecha Programada:', widget.task.fechaProgramada.toString().substring(0, 10)),
                  _buildDetailRow('Duración estimada:', '${widget.task.duracionEstimada} minutos'),
                  _buildDetailRow('Notas previas:', widget.task.notasPrevias ?? 'No hay notas previas'),
                  _buildDetailRow('Notas posteriores:', widget.task.notasPosteriores ?? 'No hay notas posteriores'),
                  const SizedBox(height: 20),
                  _buildStateDropdown(),
                  const SizedBox(height: 20),
                  if (_pdfPath != null)
                    ElevatedButton(
                      onPressed: _openPdf,
                      child: const Text('Ver Reporte'),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportScreen(visitId: widget.task.id),
                          ),
                        );
                      },
                      child: const Text('Generar Reporte'),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildStateDropdown() {
    return DropdownButtonFormField<String>(
      value: _visitState,
      decoration: const InputDecoration(
        labelText: 'Estado de la visita',
        border: OutlineInputBorder(),
      ),
      items: ['programada', 'en_camino', 'iniciada', 'completada', 'cancelada']
          .map((label) => DropdownMenuItem(
                value: label,
                child: Text(label),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
