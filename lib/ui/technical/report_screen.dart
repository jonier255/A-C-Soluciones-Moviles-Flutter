import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  final int visitId;

  const ReportScreen({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Reporte'),
      ),
      body: const Center(
        child: Text('Pantalla para generar reporte'),
      ),
    );
  }
}
