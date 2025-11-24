import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_a_c_soluciones/bloc/report/report_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';

class CreateReportScreen extends StatelessWidget {
  final int visitId;
  const CreateReportScreen({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc(reportRepository: ReportRepository()),
      child: _CreateReportView(visitId: visitId),
    );
  }
}

class _CreateReportView extends StatefulWidget {
  final int visitId;
  const _CreateReportView({required this.visitId});

  @override
  State<_CreateReportView> createState() => _CreateReportViewState();
}

class _CreateReportViewState extends State<_CreateReportView> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  // Text Controllers
  final _introduccionController = TextEditingController();
  final _detallesServicioController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _estadoAntesController = TextEditingController();
  final _descripcionTrabajoController = TextEditingController();
  final _materialesUtilizadosController = TextEditingController();
  final _estadoFinalController = TextEditingController();
  final _tiempoDeTrabajoController = TextEditingController();
  final _recomendacionesController = TextEditingController();
  final _fechaDeMantenimientoController = TextEditingController();

  // Image Files
  XFile? _fotoEstadoAntes;
  XFile? _fotoEstadoFinal;
  XFile? _fotoDescripcionTrabajo;

  // State
  Map<String, String> _fieldErrors = {};

  @override
  void dispose() {
    _introduccionController.dispose();
    _detallesServicioController.dispose();
    _observacionesController.dispose();
    _estadoAntesController.dispose();
    _descripcionTrabajoController.dispose();
    _materialesUtilizadosController.dispose();
    _estadoFinalController.dispose();
    _tiempoDeTrabajoController.dispose();
    _recomendacionesController.dispose();
    _fechaDeMantenimientoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(Function(XFile) onImagePicked) async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (!mounted) return;
      setState(() {
        onImagePicked(pickedFile);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ReportBloc>().add(
            CreateReport(
              visitId: widget.visitId,
              introduccion: _introduccionController.text,
              detallesServicio: _detallesServicioController.text,
              observaciones: _observacionesController.text,
              estadoAntes: _estadoAntesController.text,
              descripcionTrabajo: _descripcionTrabajoController.text,
              materialesUtilizados: _materialesUtilizadosController.text,
              estadoFinal: _estadoFinalController.text,
              tiempoDeTrabajo: _tiempoDeTrabajoController.text,
              recomendaciones: _recomendacionesController.text,
              fechaDeMantenimiento: _fechaDeMantenimientoController.text,
              fotoEstadoAntes: _fotoEstadoAntes,
              fotoEstadoFinal: _fotoEstadoFinal,
              fotoDescripcionTrabajo: _fotoDescripcionTrabajo,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Reporte de Mantenimiento')),
      body: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportCreationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reporte creado con éxito'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop();
          } else if (state is ReportCreationFailure) {
            if (state.fieldErrors != null) {
              setState(() {
                _fieldErrors = state.fieldErrors!;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}'), backgroundColor: Colors.red),
              );
            }
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildTextField(_introduccionController, 'Introducción', error: _fieldErrors['introduccion'], maxLines: 3),
              _buildDatePickerField(_fechaDeMantenimientoController, 'Fecha del Mantenimiento', error: _fieldErrors['fecha_de_mantenimiento']),
              _buildTextField(_detallesServicioController, 'Detalles del Servicio', error: _fieldErrors['detalles_servicio'], maxLines: 3),
              _buildTextField(_observacionesController, 'Observaciones', error: _fieldErrors['observaciones'], maxLines: 2),
              _buildTextField(_estadoAntesController, 'Estado Antes', error: _fieldErrors['estado_antes'], maxLines: 2),
              _buildImagePicker('Foto del Estado Antes', _fotoEstadoAntes, (file) => _fotoEstadoAntes = file),
              _buildTextField(_descripcionTrabajoController, 'Descripción del Trabajo', error: _fieldErrors['descripcion_trabajo'], maxLines: 3),
              _buildImagePicker('Foto de la Descripción del Trabajo', _fotoDescripcionTrabajo, (file) => _fotoDescripcionTrabajo = file),
              _buildTextField(_materialesUtilizadosController, 'Materiales Utilizados', error: _fieldErrors['materiales_utilizados']),
              _buildTextField(_estadoFinalController, 'Estado Final', error: _fieldErrors['estado_final']),
              _buildImagePicker('Foto del Estado Final', _fotoEstadoFinal, (file) => _fotoEstadoFinal = file),
              _buildTextField(_tiempoDeTrabajoController, 'Tiempo de Trabajo', error: _fieldErrors['tiempo_de_trabajo']),
              _buildTextField(_recomendacionesController, 'Recomendaciones', error: _fieldErrors['recomendaciones'], maxLines: 2),
              const SizedBox(height: 24),
              BlocBuilder<ReportBloc, ReportState>(
                builder: (context, state) {
                  final isLoading = state is ReportCreationLoading;
                  return ElevatedButton.icon(
                    icon: isLoading ? const SizedBox.shrink() : const Icon(Icons.save),
                    label: Text(isLoading ? 'Generando Reporte...' : 'Generar Reporte'),
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {String? error, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          errorText: error,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es requerido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label, {String? error}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          errorText: error,
          suffixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null && mounted) {
            controller.text = pickedDate.toLocal().toString().split(' ')[0];
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es requerido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildImagePicker(String label, XFile? file, Function(XFile) onImagePicked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: Text(label),
            onPressed: () => _pickImage(onImagePicked),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
          if (file != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.image, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(file.name, overflow: TextOverflow.ellipsis)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        if (label.contains('Antes')) _fotoEstadoAntes = null;
                        if (label.contains('Descripción')) _fotoDescripcionTrabajo = null;
                        if (label.contains('Final')) _fotoEstadoFinal = null;
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
