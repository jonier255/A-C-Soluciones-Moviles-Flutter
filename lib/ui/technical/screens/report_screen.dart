import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/technical/widgets/bottom_nav_bar.dart';

class ReportScreen extends StatelessWidget {
  final int visitId;

  const ReportScreen({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Reporte'),
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: const Center(
        child: Text('Pantalla para generar reporte'),
      ),
    );
  }
}
