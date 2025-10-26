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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Servicio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
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
                Text(
                  widget.service.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 25),
                _buildDetailRow('Descripción:', widget.service.descripcion),
                const SizedBox(height: 12),
                _buildDetailRow('Estado:', widget.service.estado),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Fecha de Creación:',
                  widget.service.fechaCreacion.toString().substring(0, 10),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Última Modificación:',
                  widget.service.fechaModificacion.toString().substring(0, 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.black87,
            ),
          ),
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
