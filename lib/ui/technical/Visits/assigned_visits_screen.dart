import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_event.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_state.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';
import 'package:flutter_a_c_soluciones/repository/task_repository.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Visits/visits_details_screen.dart';
import 'package:flutter_a_c_soluciones/ui/technical/widgets/bottom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignedVisitsScreen extends StatelessWidget {
  const AssignedVisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(taskRepository: TaskRepository())..add(LoadTasks()),
      child: const _AssignedVisitsContent(),
    );
  }
}

class _AssignedVisitsContent extends StatelessWidget {
  const _AssignedVisitsContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Visitas Asignadas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TaskSuccess || state is TaskLoadingMore) {
            final tasks = state is TaskSuccess 
                ? state.tasks 
                : (state as TaskLoadingMore).currentTasks;
            final currentPage = state is TaskSuccess ? state.currentPage : 1;
            
            if (tasks.isEmpty) {
              return const Center(child: Text("No hay visitas asignadas."));
            }
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Página $currentPage',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${tasks.length} visitas',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return _TaskCard(task: tasks[index]);
                    },
                  ),
                ),
                _PaginationWidget(
                  currentPage: currentPage,
                  totalPages: state is TaskSuccess ? state.totalPages : 1,
                  isLoading: state is TaskLoadingMore,
                  onPageChanged: (page) {
                    context.read<TaskBloc>().add(LoadMoreTasks(page));
                  },
                ),
              ],
            );
          }
          if (state is TaskFailure) {
            return Center(child: Text(state.error));
          }
          return const Center(child: Text("Cargando visitas..."));
        },
      ),
    );
  }
}

class _PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final Function(int) onPageChanged;

  const _PaginationWidget({
    required this.currentPage,
    required this.totalPages,
    required this.isLoading,
    required this.onPageChanged,
  });

  List<int> _getPageNumbers() {
    List<int> pages = [];
    
    if (totalPages <= 5) {
      // Si hay 5 o menos páginas, mostrarlas todas
      for (int i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    } else if (currentPage <= 3) {
      // Estamos al inicio, mostrar primeras 5 páginas
      for (int i = 1; i <= 5; i++) {
        pages.add(i);
      }
      pages.add(-1); // ...
    } else if (currentPage >= totalPages - 2) {
      // Estamos cerca del final
      pages.add(1);
      pages.add(-1); // ...
      for (int i = totalPages - 4; i <= totalPages; i++) {
        if (i > 1) pages.add(i);
      }
    } else {
      // Estamos en el medio
      pages.add(1);
      pages.add(-1); // ...
      
      // Mostrar páginas alrededor de la actual
      for (int i = currentPage - 1; i <= currentPage + 1; i++) {
        pages.add(i);
      }
      
      pages.add(-1); // ...
    }
    
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pages = _getPageNumbers();
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón Inicio
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage > 1 && !isLoading
                ? () => onPageChanged(1)
                : null,
            icon: const Icon(Icons.first_page, size: 20),
            color: Colors.blue,
            disabledColor: Colors.grey,
            tooltip: 'Primera página',
          ),
          // Botón Anterior
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage > 1 && !isLoading
                ? () => onPageChanged(currentPage - 1)
                : null,
            icon: const Icon(Icons.chevron_left, size: 20),
            color: Colors.blue,
            disabledColor: Colors.grey,
            tooltip: 'Página anterior',
          ),
          const SizedBox(width: 4),
          
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            ...pages.map((page) {
              if (page == -1) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('...', style: TextStyle(fontSize: 18)),
                );
              }
              
              final isCurrentPage = page == currentPage;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: InkWell(
                  onTap: isCurrentPage || isLoading ? null : () => onPageChanged(page),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isCurrentPage ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isCurrentPage ? Colors.blue : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      page.toString(),
                      style: TextStyle(
                        color: isCurrentPage ? Colors.white : Colors.black87,
                        fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          
          const SizedBox(width: 4),
          // Botón Siguiente
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage < totalPages && !isLoading
                ? () => onPageChanged(currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right, size: 20),
            color: Colors.blue,
            disabledColor: Colors.grey,
            tooltip: 'Página siguiente',
          ),
          // Botón Final
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: currentPage < totalPages && !isLoading
                ? () => onPageChanged(totalPages)
                : null,
            icon: const Icon(Icons.last_page, size: 20),
            color: Colors.blue,
            disabledColor: Colors.grey,
            tooltip: 'Última página',
          ),
        ],
      ),
    );
  }
}

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
        elevation: 6,
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.04),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.05)),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.035),
          child: Row(
            children: [
              Icon(Icons.handyman, size: screenWidth * 0.09, color: Colors.black),
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
                  color: _getStateBackgroundColor(task.estado),
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
                child: Text(
                  _getStateLabel(task.estado),
                  style: TextStyle(
                    color: _getStateTextColor(task.estado),
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.03,
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
