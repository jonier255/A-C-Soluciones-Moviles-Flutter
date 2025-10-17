import 'package:flutter/material.dart';

class ClientHomeContent extends StatelessWidget {
  const ClientHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Image.asset(
                "assets/soluciones.png",
                height: 220,
                width: 220,
              ),
            ),
          ),
          Column(
            children: [
              _buildServiceCard("assets/servicio2.jpg", "Mantenimiento"),
              _buildServiceCard("assets/servicio3.webp", "Reparaciones"),
              _buildServiceCard("assets/servicio4.jpg", "Consultoría"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String imagePath, String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E91D8),
            ),
          ),
        ],
      ),
    );
  }
}
