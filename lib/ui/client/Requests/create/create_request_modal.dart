import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../model/client/service_model.dart';
import '../../../../repository/client/solicitud_api_solicitud.dart';

class CrearSolicitudModal extends StatefulWidget {
  final int clienteId;
  final ServiceModel servicio;
  final SolicitudApiRepository repository;

  const CrearSolicitudModal({
    super.key,
    required this.clienteId,
    required this.servicio,
    required this.repository,
  });

  @override
  State<CrearSolicitudModal> createState() => _CrearSolicitudModalState();
}

class _CrearSolicitudModalState extends State<CrearSolicitudModal> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  String _direccion = '';
  String _descripcion = '';
  String _comentarios = '';
  DateTime? _fechaSolicitud;

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(today.year + 2),
    );
    if (picked != null) setState(() => _fechaSolicitud = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _loading = true);
    try {
      await widget.repository.crearSolicitud(
        clienteId: widget.clienteId,
        servicioId: widget.servicio.id,
        direccion: _direccion,
        descripcion: _descripcion,
        comentarios: _comentarios,
        fechaSolicitud: _fechaSolicitud,
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // Fondo blanco
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), // Sin bordes redondeados
      ),
      title: Text(
        'Solicitud: ${widget.servicio.nombre}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Dirección'),
                      validator: (v) => v == null || v.trim().length < 10
                          ? 'Min 10 caracteres'
                          : null,
                      onSaved: (v) => _direccion = v!.trim(),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                      validator: (v) => v == null || v.trim().length < 20
                          ? 'Min 20 caracteres'
                          : null,
                      onSaved: (v) => _descripcion = v!.trim(),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Comentarios'),
                      maxLength: 255,
                      onSaved: (v) => _comentarios = v!.trim(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(_fechaSolicitud != null
                              ? 'Fecha: ${DateFormat('yyyy-MM-dd').format(_fechaSolicitud!)}'
                              : 'Seleccione fecha'),
                        ),
                        TextButton(
                          onPressed: _pickDate,
                          child: const Text('Elegir Fecha'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Crear'),
        ),
      ],
    );
  }
}
