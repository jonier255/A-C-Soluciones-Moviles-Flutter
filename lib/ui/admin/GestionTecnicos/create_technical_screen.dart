import 'package:flutter/material.dart'; 


/// Pantalla para crear un nuevo técnico
class CreateTechnicalScreen extends StatelessWidget {
  const CreateTechnicalScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Técnico'),
      ),
      body: const Center(
        child: Text('Formulario para crear un nuevo técnico'),
      ),
    );
  }
}