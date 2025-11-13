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
      create: (context) => TaskBloc(taskRepository: TaskRepository())..add(LoadTasks()),
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
            if (state is TaskFailure) {
              return Center(child: Text(state.error));
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 6,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.05)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.035),
        child: Row(
          children: [
            Icon(Icons.check_circle, size: screenWidth * 0.09, color: Colors.green),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.servicio.nombre,
                      style: TextStyle(
                          fontSize: screenWidth * 0.038, fontWeight: FontWeight.bold)),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    task.servicio.descripcion.length > 50
                          ? '${task.servicio.descripcion.substring(0, 50)}...'
                          : task.servicio.descripcion,
                    style: TextStyle(fontSize: screenWidth * 0.032, color: Colors.grey),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text("Fecha: ${task.fechaProgramada.toString().substring(0, 10)}",
                      style:
                          TextStyle(fontSize: screenWidth * 0.032, color: Colors.grey)),
                ],
              ),
            ),
            Container(padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenHeight * 0.008),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              child: Text(
                task.estado,
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.03,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
