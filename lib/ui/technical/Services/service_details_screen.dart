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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Servicio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.05,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildDetailRow('Descripción:', widget.service.descripcion, screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.015),
                _buildDetailRow('Estado:', widget.service.estado, screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.015),
                _buildDetailRow(
                  'Fecha de Creación:',
                  widget.service.fechaCreacion.toString().substring(0, 10),
                  screenWidth, screenHeight
                ),
                SizedBox(height: screenHeight * 0.015),
                _buildDetailRow(
                  'Última Modificación:',
                  widget.service.fechaModificacion.toString().substring(0, 10),
                  screenWidth, screenHeight
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.042,
              color: Colors.black87,
            ),
          ),
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