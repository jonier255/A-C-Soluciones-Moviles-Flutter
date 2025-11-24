import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';
import 'package:flutter_a_c_soluciones/repository/task_repository.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Reports/create_report_screen.dart';
import 'package:flutter_a_c_soluciones/ui/technical/widgets/bottom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

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
    if (newState == null || newState == _visitState) return;
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
        await OpenFile.open(file.path);
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
          'Detalles de la Visita',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
              ),
              child: Column(
                children: [
                  // Card con descripción
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE3F2FD), Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.description, color: Colors.blue, size: 20),
                              SizedBox(width: screenWidth * 0.02),
                              Text(
                                'Descripción',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.038,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          Text(
                            widget.task.servicio.descripcion,
                            style: TextStyle(
                              fontSize: screenWidth * 0.032,
                              color: Colors.grey[800],
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Card con información detallada
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                              SizedBox(width: screenWidth * 0.02),
                              Text(
                                'Información',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.038,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          _buildDetailRow(
                            Icons.note_alt_outlined,
                            'Notas previas:',
                            widget.task.notasPrevias ?? '',
                            screenWidth,
                            screenHeight,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildDetailRow(
                            Icons.notes,
                            'Notas posteriores:',
                            widget.task.notasPosteriores ?? '',
                            screenWidth,
                            screenHeight,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildDetailRow(
                            Icons.calendar_today,
                            'Fecha programada:',
                            widget.task.fechaProgramada.toString().substring(0, 10),
                            screenWidth,
                            screenHeight,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildDetailRow(
                            Icons.timer_outlined,
                            'Duración estimada:',
                            '${widget.task.duracionEstimada} minutos',
                            screenWidth,
                            screenHeight,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Card con estado
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _buildStateDropdown(screenWidth, screenHeight),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Botón de reporte
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _visitState == 'completada'
                            ? [Colors.blue[600]!, Colors.blue[400]!]
                            : [Colors.grey[400]!, Colors.grey[300]!],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: _visitState == 'completada'
                          ? [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : [],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _visitState != 'completada'
                          ? null
                          : (_pdfPath != null
                              ? _openPdf
                              : () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateReportScreen(visitId: widget.task.id),
                                    ),
                                  );
                                  if (result == true && mounted) {
                                    await _fetchPdfPath();
                                  }
                                }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.grey[600],
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.012,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      icon: Icon(
                        _pdfPath != null ? Icons.picture_as_pdf : Icons.add_circle_outline,
                        size: screenWidth * 0.045,
                      ),
                      label: Text(
                        _pdfPath != null ? 'Ver reporte' : 'Generar reporte',
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (_visitState != 'completada')
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: screenWidth * 0.04, color: Colors.grey[600]),
                          SizedBox(width: screenWidth * 0.015),
                          Text(
                            'Completa la visita para generar el reporte',
                            style: TextStyle(
                              fontSize: screenWidth * 0.032,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
    );
  }

  Widget _buildStateDropdown(double screenWidth, double screenHeight) {
    // Mapa de estados internos a nombres amigables
    final Map<String, String> stateLabels = {
      'programada': 'Programada',
      'en_camino': 'En camino',
      'iniciada': 'Iniciada',
      'completada': 'Completada',
      'cancelada': 'Cancelada',
    };

    // Mapa de estados a colores e iconos
    final Map<String, Map<String, dynamic>> stateStyles = {
      'programada': {'color': Colors.orange[700], 'icon': Icons.schedule},
      'en_camino': {'color': Colors.blue[700], 'icon': Icons.directions_car},
      'iniciada': {'color': Colors.green[700], 'icon': Icons.play_circle_outline},
      'completada': {'color': Colors.green[900], 'icon': Icons.check_circle},
      'cancelada': {'color': Colors.red[700], 'icon': Icons.cancel},
    };

    final bool isDisabled = ['completada', 'cancelada'].contains(_visitState);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flag_outlined,
              color: Colors.blue[700],
              size: screenWidth * 0.055,
            ),
            SizedBox(width: screenWidth * 0.02),
            Flexible(
              child: Text(
                'Estado de la visita',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.043,
                  color: Colors.grey[800],
                  height: 1.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.015),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDisabled ? Colors.grey[400]! : Colors.blue[300]!,
              width: 1.5,
            ),
            color: isDisabled ? Colors.grey[100] : Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            initialValue: _visitState,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.014,
              ),
            ),
            dropdownColor: Colors.white,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDisabled ? Colors.grey[400] : Colors.blue[700],
              size: screenWidth * 0.055,
            ),
            items: stateLabels.entries.map((entry) {
              final stateValue = entry.key;
              final stateLabel = entry.value;
              final style = stateStyles[stateValue];
              
              return DropdownMenuItem(
                value: stateValue,
                child: Row(
                  children: [
                    Icon(
                      style?['icon'] ?? Icons.help_outline,
                      color: style?['color'] ?? Colors.grey,
                      size: screenWidth * 0.045,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      stateLabel,
                      style: TextStyle(
                        fontSize: screenWidth * 0.036,
                        fontWeight: FontWeight.w500,
                        color: style?['color'] ?? Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: isDisabled ? null : _handleStateChange,
          ),
        ),
        if (isDisabled)
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.01, left: screenWidth * 0.02),
            child: Row(
              children: [
                Icon(Icons.lock_outline, size: screenWidth * 0.04, color: Colors.grey[600]),
                SizedBox(width: screenWidth * 0.015),
                Text(
                  'El estado no puede modificarse',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.025),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[700], size: screenWidth * 0.04),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.032,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),
                Text(
                  value.isNotEmpty ? value : '—',
                  style: TextStyle(
                    fontSize: screenWidth * 0.034,
                    color: Colors.grey[900],
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
