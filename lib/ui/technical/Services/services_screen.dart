import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/service/service_bloc.dart';
import '../../../bloc/service/service_event.dart';
import '../../../bloc/service/service_state.dart';
import '../../../model/servicio_model.dart';
import '../../../repository/service_repository.dart';
import 'service_details_screen.dart';
import 'package:flutter_a_c_soluciones/ui/technical/widgets/bottom_nav_bar.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc(repository: ServiceRepository())..add(LoadServices()),
      child: const _ServicesContent(),
    );
  }
}

class _ServicesContent extends StatelessWidget {
  const _ServicesContent();

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
          'Servicios',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ServiceSuccess || state is ServiceLoadingMore) {
            final services = state is ServiceSuccess 
                ? state.services 
                : (state as ServiceLoadingMore).currentServices;
            final currentPage = state is ServiceSuccess ? state.currentPage : 1;
            
            if (services.isEmpty) {
              return const Center(child: Text("No hay servicios disponibles."));
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
                        '${services.length} servicios',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return _ServiceCard(service: services[index]);
                    },
                  ),
                ),
                _PaginationWidget(
                  currentPage: currentPage,
                  totalPages: state is ServiceSuccess ? state.totalPages : 1,
                  isLoading: state is ServiceLoadingMore,
                  onPageChanged: (page) {
                    context.read<ServiceBloc>().add(LoadMoreServices(page));
                  },
                ),
              ],
            );
          }
          if (state is ServiceFailure) {
            return Center(child: Text(state.error));
          }
          return const Center(child: Text("Cargando servicios..."));
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
            color: Colors.grey.withOpacity(0.3),
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
          const SizedBox(width: 8),
          
          // Números de página
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

class _ServiceCard extends StatelessWidget {
  final Servicio service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(service: service),
          ),
        );
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
              Icon(Icons.miscellaneous_services, size: screenWidth * 0.09, color: Colors.black),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.nombre,
                      style: TextStyle(
                        fontSize: screenWidth * 0.038,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      service.descripcion,
                      style: TextStyle(fontSize: screenWidth * 0.032, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenHeight * 0.008),
                decoration: BoxDecoration(
                  color: service.estado == "activo"
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
                child: Text(
                  service.estado,
                  style: TextStyle(
                    color: service.estado == "activo"
                        ? Colors.green[800]
                        : Colors.orange[800],
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
