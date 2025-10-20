import 'package:flutter/material.dart';

class RequestsContent extends StatelessWidget {
  const RequestsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Título
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            "📄 Mis Solicitudes",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E91D8),
            ),
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildRequestCard(
                "Solicitud #001",
                "Mantenimiento preventivo",
                "En revisión",
                Icons.pending_actions,
                Colors.orange,
              ),
              _buildRequestCard(
                "Solicitud #002",
                "Instalación de software",
                "Aprobada",
                Icons.check_circle,
                Colors.green,
              ),
              _buildRequestCard(
                "Solicitud #003",
                "Reparación de equipo",
                "En proceso",
                Icons.build,
                Colors.blue,
              ),
              _buildRequestCard(
                "Solicitud #004",
                "Consulta técnica",
                "Completada",
                Icons.verified,
                Colors.purple,
              ),
            ],
          ),
        ),

        // 🔹 Botón para nueva solicitud
        Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            label: const Text("Nueva Solicitud"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 46, 145, 216),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad en desarrollo 🚧'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRequestCard(
    String id,
    String title,
    String status,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(id),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
