import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';

class VisitsDetailsScreen extends StatelessWidget {
  final TaskModel task;

  const VisitsDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Información de la Visita",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.6),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Descripción
                const Text(
                  "Descripción",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  task.servicio.descripcion,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Información general
                const Text(
                  "Información",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),

                _buildDetailSection("Notas previas:", "Visita para revisar y arreglar una alcantarilla"),
                _buildDetailSection("Notas posteriores:", "Urgente"),
                _buildDetailSection("Fecha programada:", task.fechaProgramada.toString().substring(0, 10)),
                _buildDetailSection("Duración estimada:", "150 minutos"),
                const SizedBox(height: 25),

                // Estado dropdown y botón
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Estado",
                          labelStyle: const TextStyle(fontSize: 15),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: "Pendiente", child: Text("Pendiente")),
                          DropdownMenuItem(value: "Completada", child: Text("Completada")),
                          DropdownMenuItem(value: "Cancelada", child: Text("Cancelada")),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Generar reporte",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget reutilizable para cada fila de información ---
  Widget _buildDetailSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.only(bottom: 4),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.blueAccent, width: 1)),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
