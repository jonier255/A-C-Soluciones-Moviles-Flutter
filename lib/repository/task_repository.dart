import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';

class TaskRepository {
  /// Obtiene la lista de tareas.
  ///
  /// TODO: Reemplazar esta implementación de ejemplo con una llamada a la API real.
  Future<List<TaskModel>> getTasks() async {
    // Simula un retraso de red
    await Future.delayed(const Duration(seconds: 1));

    // Devuelve una lista de tareas de ejemplo.
    // En un caso real, aquí harías una petición HTTP a tu backend.
    return [
      TaskModel(
          title: "Revisión de motor hidráulico",
          location: "Planta principal - Zona 3",
          date: "2025-10-10",
          status: "Pendiente"),
      TaskModel(
          title: "Cambio de filtro de aire",
          location: "Taller 2 - Norte",
          date: "2025-10-12",
          status: "Completada"),
      // Agrega más tareas si es necesario
    ];
  }
}