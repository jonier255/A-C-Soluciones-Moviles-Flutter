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
  final _pageController = PageController();
  int _currentPage = 0;

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
    _pageController.dispose();
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

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Reporte de Mantenimiento'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (_currentPage + 1) / 4,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          // ignore: avoid_print
          print('🟣 [UI] BlocListener recibió estado: ${state.runtimeType}');
          
          if (state is ReportCreationSuccess) {
            // ignore: avoid_print
            print('✅ [UI] Estado es ReportCreationSuccess - Mostrando SnackBar y navegando...');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reporte creado con éxito'), backgroundColor: Colors.green),
            );
            // Regresar a la pantalla anterior con resultado true para indicar éxito
            Navigator.of(context).pop(true);
            // ignore: avoid_print
            print('✅ [UI] Navegación completada');
          } else if (state is ReportCreationFailure) {
            // ignore: avoid_print
            print('❌ [UI] Estado es ReportCreationFailure: ${state.error}');
            if (state.fieldErrors != null) {
              setState(() {
                _fieldErrors = state.fieldErrors!;
              });
              // Scroll a la página con errores si es necesario
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, corrija los errores en el formulario'),
                  backgroundColor: Colors.orange,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}'), backgroundColor: Colors.red),
              );
            }
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildPage1(),
                    _buildPage2(),
                    _buildPage3(),
                    _buildPage4(),
                  ],
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Información General',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Paso 1 de 4',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          _introduccionController,
          'Introducción',
          error: _fieldErrors['introduccion'],
          maxLines: 5,
          hint: 'Proporcione una introducción detallada del reporte de mantenimiento',
        ),
        _buildDatePickerField(
          _fechaDeMantenimientoController,
          'Fecha del Mantenimiento',
          error: _fieldErrors['fecha_de_mantenimiento'],
        ),
        _buildTextField(
          _detallesServicioController,
          'Detalles del Servicio',
          error: _fieldErrors['detalles_servicio'],
          maxLines: 5,
          hint: 'Describa los detalles completos del servicio realizado',
        ),
        _buildTextField(
          _observacionesController,
          'Observaciones',
          error: _fieldErrors['observaciones'],
          maxLines: 4,
          hint: 'Incluya cualquier observación relevante',
        ),
      ],
    );
  }

  Widget _buildPage2() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Estado Inicial',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Paso 2 de 4',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          _estadoAntesController,
          'Estado Antes del Mantenimiento',
          error: _fieldErrors['estado_antes'],
          maxLines: 6,
          hint: 'Describa el estado del equipo o sistema antes del mantenimiento',
        ),
        const SizedBox(height: 16),
        _buildImagePicker(
          'Foto del Estado Antes',
          _fotoEstadoAntes,
          (file) => _fotoEstadoAntes = file,
        ),
      ],
    );
  }

  Widget _buildPage3() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Trabajo Realizado',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Paso 3 de 4',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          _descripcionTrabajoController,
          'Descripción del Trabajo',
          error: _fieldErrors['descripcion_trabajo'],
          maxLines: 6,
          hint: 'Detalle el trabajo realizado paso a paso',
        ),
        const SizedBox(height: 16),
        _buildImagePicker(
          'Foto de la Descripción del Trabajo',
          _fotoDescripcionTrabajo,
          (file) => _fotoDescripcionTrabajo = file,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          _materialesUtilizadosController,
          'Materiales Utilizados',
          error: _fieldErrors['materiales_utilizados'],
          maxLines: 4,
          hint: 'Liste todos los materiales y herramientas utilizados',
        ),
        _buildTextField(
          _tiempoDeTrabajoController,
          'Tiempo de Trabajo',
          error: _fieldErrors['tiempo_de_trabajo'],
          maxLines: 1,
          hint: 'Ej: 2 horas',
        ),
      ],
    );
  }

  Widget _buildPage4() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Estado Final y Recomendaciones',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Paso 4 de 4',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          _estadoFinalController,
          'Estado Final',
          error: _fieldErrors['estado_final'],
          maxLines: 5,
          hint: 'Describa el estado final después del mantenimiento',
        ),
        const SizedBox(height: 16),
        _buildImagePicker(
          'Foto del Estado Final',
          _fotoEstadoFinal,
          (file) => _fotoEstadoFinal = file,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          _recomendacionesController,
          'Recomendaciones',
          error: _fieldErrors['recomendaciones'],
          maxLines: 5,
          hint: 'Proporcione recomendaciones para mantenimientos futuros',
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Anterior'),
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            flex: _currentPage == 0 ? 1 : 1,
            child: BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                final isLoading = state is ReportCreationLoading;
                final isLastPage = _currentPage == 3;
                
                return ElevatedButton.icon(
                  icon: isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(isLastPage ? Icons.check : Icons.arrow_forward),
                  label: Text(
                    isLoading 
                        ? 'Generando...' 
                        : (isLastPage ? 'Generar Reporte' : 'Siguiente')
                  ),
                  onPressed: isLoading ? null : (isLastPage ? _submitForm : _nextPage),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    String? error,
    int maxLines = 1,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: error,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
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
          filled: true,
          fillColor: Colors.grey[50],
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
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: Text(file == null ? 'Seleccionar Imagen' : 'Cambiar Imagen'),
              onPressed: () => _pickImage(onImagePicked),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            if (file != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          file.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.green[900]),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.red,
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
              ),
          ],
        ),
      ),
    );
  }
}
