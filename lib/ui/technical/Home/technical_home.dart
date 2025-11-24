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
            padding: EdgeInsets.zero,
            children: [
              const _HeaderSection(),
              const SizedBox(height: 12),
              const _MainButtonsSection(),
              const SizedBox(height: 12),
              const _QuickAccessSection(),
              const SizedBox(height: 12),
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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.015,
      ),
      child: Center(
        child: Image.asset(
          "assets/soluciones.png",
          height: screenHeight * 0.14,
          width: screenWidth * 0.75,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
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
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.11,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[700]!, Colors.blue[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: screenWidth * 0.1, color: Colors.white),
            SizedBox(height: screenHeight * 0.008),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.042,
              ),
            ),
          ],
        ),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.014,
          horizontal: screenWidth * 0.03,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.blue[200]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.blue[700],
              size: screenWidth * 0.06,
            ),
            SizedBox(width: screenWidth * 0.02),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: Colors.blue[700],
                size: screenWidth * 0.07,
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                "Tareas recientes",
                style: TextStyle(
                  fontSize: screenWidth * 0.052,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015),
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
                    SizedBox(height: screenHeight * 0.015), // Responsive height
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[700]!, Colors.blue[500]!],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              Navigator.pushNamed(context, '/technical_assigned_visits');
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.06,
                                vertical: screenHeight * 0.012,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Ver más",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: screenWidth * 0.05,
                                  ),
                                ],
                              ),
                            ),
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
// Función helper para obtener la etiqueta amigable del estado
String _getStateLabel(String state) {
  const Map<String, String> stateLabels = {
    'programada': 'Programada',
    'en_camino': 'En camino',
    'iniciada': 'Iniciada',
    'completada': 'Completada',
    'cancelada': 'Cancelada',
  };
  return stateLabels[state] ?? state;
}

// Función helper para obtener el color de fondo del estado
Color? _getStateBackgroundColor(String state) {
  const Map<String, int> stateColorValues = {
    'programada': 0xFFFFF3E0,  // Colors.orange[100]
    'en_camino': 0xFFE3F2FD,   // Colors.blue[100]
    'iniciada': 0xFFC8E6C9,    // Colors.green[100]
    'completada': 0xFFC8E6C9,  // Colors.green[100]
    'cancelada': 0xFFFFCDD2,   // Colors.red[100]
  };
  final colorValue = stateColorValues[state];
  return colorValue != null ? Color(colorValue) : Colors.grey[100];
}

// Función helper para obtener el color del texto del estado
Color? _getStateTextColor(String state) {
  const Map<String, int> stateColorValues = {
    'programada': 0xFFE65100,  // Colors.orange[800]
    'en_camino': 0xFF1565C0,   // Colors.blue[800]
    'iniciada': 0xFF2E7D32,    // Colors.green[800]
    'completada': 0xFF1B5E20,  // Colors.green[900]
    'cancelada': 0xFFC62828,   // Colors.red[800]
  };
  final colorValue = stateColorValues[state];
  return colorValue != null ? Color(colorValue) : Colors.grey[800];
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;

  const _TaskCard({required this.task});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisitsDetailsScreen(task: task),
          ),
        );
        // Recargar la lista cuando se regresa
        if (context.mounted) {
          context.read<TaskBloc>().add(LoadTasks());
        }
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.006,
          horizontal: screenWidth * 0.04,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.blue[100]!,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.035),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.025),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[700]!, Colors.blue[500]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.handyman,
                    size: screenWidth * 0.07,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.servicio.nombre.length > 30
                            ? '${task.servicio.nombre.substring(0, 30)}...'
                            : task.servicio.nombre,
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.004),
                      Text(
                        task.servicio.descripcion.length > 30
                            ? '${task.servicio.descripcion.substring(0, 30)}...'
                            : task.servicio.descripcion,
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.004),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: screenWidth * 0.03,
                            color: Colors.grey[500],
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Text(
                            task.fechaProgramada.toString().substring(0, 10),
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.022,
                    vertical: screenHeight * 0.006,
                  ),
                  decoration: BoxDecoration(
                    color: _getStateBackgroundColor(task.estado),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _getStateLabel(task.estado),
                    style: TextStyle(
                      color: _getStateTextColor(task.estado),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.028,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
