import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_event.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_state.dart';
import 'package:flutter_a_c_soluciones/repository/task_repository.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Visits/visits_details_screen.dart';
import 'package:flutter_a_c_soluciones/ui/technical/widgets/bottom_nav_bar.dart';

class TechnicalHomeScreen extends StatelessWidget {
  const TechnicalHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(taskRepository: TaskRepository())..add(LoadTasks()),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const BottomNavBar(),
        body: SafeArea(
          child: ListView(
            children: [
              const _HeaderSection(),
              const SizedBox(height: 20),
              const _MainButtonsSection(),
              const SizedBox(height: 20),
              const _QuickAccessSection(),
              const SizedBox(height: 20),
              const _RecentTasksSection(), // Reemplaza solicitudes por tareas o mantenimientos
            ],
          ),
        ),
      ),
    );
  }
}

// Header con logo y buscador
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // Responsive horizontal padding
      child: Column(
        children: [
          Center(
            child: Image.asset(
              "assets/soluciones.png",
              height: screenHeight * 0.15, // Responsive height
            ),
          ),
          SizedBox(height: screenHeight * 0.01), // Responsive height
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar tarea o cliente",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF0F2F5),
                contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.01), // Responsive vertical padding
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Botones principales (por ejemplo: Asignadas y Finalizadas)
class _MainButtonsSection extends StatelessWidget {
  const _MainButtonsSection();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.005), // Responsive horizontal padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/technical_assigned_visits');
            },
            child: const _MainButton(icon: Icons.work_outline, label: "Asignadas"),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/technical_reports');
            },
            child: const _MainButton(icon: Icons.description, label: "Reportes"),
          ),
        ],
      ),
    );
  }
}

class _MainButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MainButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.38,
      height: screenHeight * 0.13,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 17, 115, 196),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: screenWidth * 0.11, color: Colors.white),
          SizedBox(height: screenHeight * 0.007),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
            ),
          ),
        ],
      ),
    );
  }
}

// Accesos rápidos para funciones del técnico
class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // Responsive horizontal padding
      child: Row(
        children: [
          SizedBox(width: screenWidth * 0.03), // Responsive width
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/technical_services');
              },
              child:
                  const _QuickButton(icon: Icons.miscellaneous_services, label: "Servicios"),
            ),
          ),
          SizedBox(width: screenWidth * 0.03), // Responsive width
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/technical_completed_visits');
              },
              child: const _QuickButton(
                  icon: Icons.check_circle_outline, label: "Finalizadas"),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.02), // Responsive padding
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: screenWidth * 0.05), // Responsive icon size
          SizedBox(width: screenWidth * 0.02), // Responsive width
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: screenWidth * 0.035, fontWeight: FontWeight.bold), // Responsive font size
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentTasksSection extends StatelessWidget {
  const _RecentTasksSection();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tareas recientes",
            style: TextStyle(
              fontSize: screenWidth * 0.05, // Responsive font size
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 4.0,
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: const Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.01), // Responsive height
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is TaskSuccess) {
                final recentTasks = state.tasks.take(2).toList();
                if (recentTasks.isEmpty) {
                  return const Center(child: Text("No hay tareas recientes."));
                }
                return Column(
                  children: [
                        Column(
                          children: recentTasks
                              .map((task) => _TaskCard(task: task))
                              .toList(),
                        ),
                    SizedBox(height: screenHeight * 0.01), // Responsive height
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/technical_assigned_visits');
                        },
                        child: Text(
                          "Ver más...",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // Responsive font size
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.black.withValues(alpha: 0.5),
                                offset: const Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is TaskFailure) {
                return Center(child: Text(state.error));
              }
              return const Center(child: Text("Cargando tareas..."));
            },
          ),
        ],
      ),
    );
  }
}


// Tarjeta de tarea individual
class _TaskCard extends StatelessWidget {
  final TaskModel task;

  const _TaskCard({required this.task});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisitsDetailsScreen(task: task),
          ),
        );
      },
      child: Card(
        elevation: 6,
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.04), // Responsive margin
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.035), // Responsive padding
          child: Row(
            children: [
              Icon(Icons.handyman, size: screenWidth * 0.09, color: Colors.black), // Responsive icon size
              SizedBox(width: screenWidth * 0.04), // Responsive width
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.servicio.nombre.length > 35
                          ? '${task.servicio.nombre.substring(0, 35)}...'
                          : task.servicio.nombre,
                      style: TextStyle(
                          fontSize: screenWidth * 0.035, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.005), // Responsive height
                    Text(
                      task.servicio.descripcion.length > 35
                          ? '${task.servicio.descripcion.substring(0, 35)}...'
                          : task.servicio.descripcion,
                      style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey), // Responsive font size
                    ),
                    SizedBox(height: screenHeight * 0.005), // Responsive height
                    Text("Fecha: ${task.fechaProgramada.toString().substring(0, 10)}",
                        style:
                            TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey)), // Responsive font size
                  ],
                ),
              ),
              Container(padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenHeight * 0.008), // Responsive padding
                decoration: BoxDecoration(
                  color: task.estado == "completada"
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task.estado,
                  style: TextStyle(
                    color: task.estado == "completada"
                        ? Colors.green[800]
                        : Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.03, // Responsive font size
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
