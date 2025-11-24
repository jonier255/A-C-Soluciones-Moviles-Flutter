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
          'Detalles del Servicio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            // Card con nombre del servicio
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: screenWidth * 0.9,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE3F2FD), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.business_center,
                      color: Colors.blue[800],
                      size: screenWidth * 0.08,
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Text(
                        widget.service.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.052,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Card con información del servicio
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: screenWidth * 0.9,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue, size: 28),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          'Información del Servicio',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.052,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildDetailRow(
                      Icons.description,
                      'Descripción:',
                      widget.service.descripcion,
                      screenWidth,
                      screenHeight,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildDetailRow(
                      Icons.flag_outlined,
                      'Estado:',
                      widget.service.estado,
                      screenWidth,
                      screenHeight,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Fecha de Creación:',
                      widget.service.fechaCreacion.toString().substring(0, 10),
                      screenWidth,
                      screenHeight,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildDetailRow(
                      Icons.update,
                      'Última Modificación:',
                      widget.service.fechaModificacion.toString().substring(0, 10),
                      screenWidth,
                      screenHeight,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
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
      padding: EdgeInsets.all(screenWidth * 0.035),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[700], size: screenWidth * 0.055),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  value.isNotEmpty ? value : '—',
                  style: TextStyle(
                    fontSize: screenWidth * 0.042,
                    color: Colors.grey[900],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}