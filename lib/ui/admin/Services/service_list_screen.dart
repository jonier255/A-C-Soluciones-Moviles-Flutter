import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/common_widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/service/service_bloc.dart';
import '../../../bloc/service/service_event.dart';
import '../../../bloc/service/service_state.dart';
import '../../../model/servicio_model.dart';
import '../Home/widgets/bottom_nav_bar.dart';
import 'widgets/service_menu_constants.dart';

class ServiceListScreen extends StatefulWidget { 
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  int _currentPage = 1;
  static const int _itemsPerPage = 4;
  
  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(LoadServices());
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;   
    final sh = MediaQuery.of(context).size.height;  
    
    return Scaffold(
      backgroundColor: ServiceMenuTheme.backgroundColor,
      bottomNavigationBar: const AdminBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, sw, sh),
            
            Expanded(
   
              child: BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  if (state is ServiceLoading) {
                    return _buildLoadingState();
                  } 
                  else if (state is ServiceSuccess) {
                    return _buildSuccessState(state.services, sw, sh);
                  }
                  else if (state is ServiceFailure) {
                    return _buildErrorState(state.error, sw);
                  }
                  return _buildEmptyState(sw);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double sw, double sh) {
    return Container(
      height: sh * 0.15,  
      decoration: const BoxDecoration(
        gradient: ServiceMenuTheme.primaryGradient,  
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ServiceMenuTheme.screenHorizontalPadding(sw),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              iconSize: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lista de Servicios',
                    style: TextStyle(
                      fontSize: ServiceMenuTheme.headerTitleSize(sw),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Servicios registrados en el sistema',
                    style: TextStyle(
                      fontSize: ServiceMenuTheme.headerSubtitleSize(sw),
                      color: Colors.white.withAlpha(230),
                    ),
                  ),
                ],
              ),
            ),
            
            IconButton(
              onPressed: () {
                context.read<ServiceBloc>().add(LoadServices());
              },
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              iconSize: 24,
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildLoadingState() {
    return const LoadingIndicator(
      message: 'Cargando servicios...',
      color: ServiceMenuTheme.primaryPurple,
    );
  }

  
  Widget _buildSuccessState(List<Servicio> services, double sw, double sh) {
    if (services.isEmpty) {
      return _buildEmptyState(sw);
    }

    final totalPages = (services.length / _itemsPerPage).ceil();
    final safePage = _currentPage.clamp(1, totalPages);
    final startIndex = (safePage - 1) * _itemsPerPage;
    final endIndex = (safePage * _itemsPerPage).clamp(0, services.length);
    final currentServices = services.sublist(startIndex, endIndex);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(ServiceMenuTheme.screenHorizontalPadding(sw)),
            itemCount: currentServices.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: sh * 0.015),
                child: _buildServiceCard(currentServices[index], sw),
              );
            },
          ),
        ),
        if (services.isNotEmpty)
          PaginationControls(
            currentPage: safePage,
            totalPages: totalPages,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            primaryColor: ServiceMenuTheme.primaryPurple,
            selectedColor: ServiceMenuTheme.primaryPurple,
          ),
      ],
    );
  }

  
  Widget _buildServiceCard(Servicio service, double sw) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,  
      child: InkWell(  
        onTap: () {
        
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(ServiceMenuTheme.cardPadding(sw)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ServiceMenuTheme.cardBorder,  
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: ServiceMenuTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.build_rounded,  
                      color: Colors.white,
                      size: ServiceMenuTheme.cardIconSize(sw) * 0.8,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.nombre, 
                          style: TextStyle(
                            fontSize: ServiceMenuTheme.cardTitleSize(sw),
                            fontWeight: FontWeight.bold,
                            color: ServiceMenuTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusText(service.estado),  
                          style: TextStyle(
                            fontSize: ServiceMenuTheme.cardSubtitleSize(sw) * 0.9,
                            color: _getStatusColor(service.estado),  
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Descripción del servicio
              Text(
                service.descripcion,
                style: TextStyle(
                  fontSize: ServiceMenuTheme.cardSubtitleSize(sw),
                  color: ServiceMenuTheme.textSecondary,
                  height: 1.4, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, double sw) {
    return ErrorState(
      error: error,
      onRetry: () {
        context.read<ServiceBloc>().add(LoadServices());
      },
    );
  }

  
  Widget _buildEmptyState(double sw) {
    return const EmptyState(
      icon: Icons.inventory_2_outlined,
      title: 'No hay servicios registrados',
      message: 'Crea tu primer servicio para comenzar',
      iconColor: ServiceMenuTheme.textSecondary,
    );
  }

  
  String _getStatusText(String estado) {
    switch (estado.toLowerCase()) {  
      case 'activo':
        return 'Activo';
      case 'inactivo':
        return 'Inactivo';
      default:
        return estado;  
    }
  }

  
  Color _getStatusColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'activo':
        return ServiceMenuTheme.statusCompleted;  // Verde
      case 'inactivo':
        return ServiceMenuTheme.textSecondary;    // Gris
      default:
        return ServiceMenuTheme.statusPending;    // Amarillo
    }
  }
}
