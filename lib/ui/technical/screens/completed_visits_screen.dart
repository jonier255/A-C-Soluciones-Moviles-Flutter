import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_event.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_state.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';
import 'package:flutter_a_c_soluciones/repository/task_repository.dart';
import 'package:flutter_a_c_soluciones/ui/technical/widgets/bottom_nav_bar.dart';

class CompletedVisitsScreen extends StatelessWidget {
  const CompletedVisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(TaskRepository())..add(FetchTasks()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Visitas Terminadas'),
        ),
        bottomNavigationBar: const BottomNavBar(),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TaskSuccess) {
              final completedTasks = state.tasks.where((task) => task.estado == 'completada').toList();
              if (completedTasks.isEmpty) {
                return const Center(child: Text("No hay visitas terminadas."));
              }
              return ListView.builder(
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  return _TaskCard(task: completedTasks[index]);
                },
              );
            }
            if (state is TaskError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Cargando visitas..."));
          },
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle, size: 35, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.servicio.nombre,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    task.servicio.descripcion.length > 50
                        ? '${task.servicio.descripcion.substring(0, 50)}...'
                        : task.servicio.descripcion,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text("Fecha: ${task.fechaProgramada.toString().substring(0, 10)}",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task.estado,
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
