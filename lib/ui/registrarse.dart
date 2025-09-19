import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Volver",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              
              const SizedBox(height: 5),
            Image.asset(
              "assets/soluciones.png", 
              height: 200,
            ),
            const SizedBox(height: 15),

              //Tarjeta
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInput("Nombres", "Ingresa tus nombres"),
                    const SizedBox(height: 16),
                    _buildInput("Apellidos", "Ingresa tus apellidos"),
                    const SizedBox(height: 16),
                    _buildInput("Correo electrónico", "Ingresa tu correo"),
                    const SizedBox(height: 16),
                    _buildInput("Contraseña", "Ingresa tu contraseña", obscure: true),
                    const SizedBox(height: 16),
                    _buildInput("Cédula", "Ingresa tu número de cédula"),
                    const SizedBox(height: 16),
                    _buildInput("Teléfono", "Ingresa tu teléfono"),
                    const SizedBox(height: 16),
                    _buildInput("Dirección", "Ingresa tu dirección"),
                    const SizedBox(height: 20),

                    // Boton Crear cuenta
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Accion de crear cuenta
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Crear cuenta",
                          style: TextStyle(
                              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// crear campos de texto
  Widget _buildInput(String label, String hint, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
