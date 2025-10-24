import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/model/servicio_model.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Servicio service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service.nombre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles del Servicio',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Nombre:', widget.service.nombre),
            _buildDetailRow('Descripción:', widget.service.descripcion),
            _buildDetailRow('Estado:', widget.service.estado),
            _buildDetailRow('Fecha de Creación:', widget.service.fechaCreacion.toString().substring(0, 10)),
            _buildDetailRow('Última Modificación:', widget.service.fechaModificacion.toString().substring(0, 10)),
          ],
        ),
      ),
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
