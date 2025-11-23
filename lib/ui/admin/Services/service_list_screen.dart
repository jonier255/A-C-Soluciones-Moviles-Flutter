import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/service/service_bloc.dart';
import '../../../bloc/service/service_event.dart';
import '../../../bloc/service/service_state.dart';
import '../../../model/servicio_model.dart';
import 'widgets/service_menu_constants.dart';

class ServiceListScreen extends StatefulWidget { 
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    context.read<ServiceBloc>().add(LoadServices());
    
    
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
 
  void _onScroll() {
    
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      
      final state = context.read<ServiceBloc>().state;
      
      
      if (state is ServiceSuccess && 
          state.hasMorePages && 
          state is! ServiceLoadingMore) {
        context.read<ServiceBloc>().add(
          LoadMoreServices(state.currentPage + 1)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;   
    final sh = MediaQuery.of(context).size.height;  
    
    return Scaffold(
      backgroundColor: ServiceMenuTheme.backgroundColor,  
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
                    return _buildSuccessState(state.services, state.hasMorePages, sw, sh);
                  }
                  else if (state is ServiceLoadingMore) {
                    return _buildSuccessState(state.currentServices, true, sw, sh);
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
      decoration: BoxDecoration(
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,  
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              ServiceMenuTheme.primaryPurple,  
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando servicios...',
            style: TextStyle(
              fontSize: 16,
              color: ServiceMenuTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildSuccessState(List<Servicio> services, bool hasMorePages, double sw, double sh) {
    if (services.isEmpty) {
      return _buildEmptyState(sw);  
    }

    return ListView.builder(
      controller: _scrollController,  
      physics: const BouncingScrollPhysics(),  
      padding: EdgeInsets.all(ServiceMenuTheme.screenHorizontalPadding(sw)),
      itemCount: services.length + (hasMorePages ? 1 : 0),
      
      itemBuilder: (context, index) {
        if (index >= services.length) {
          return _buildLoadingMoreIndicator();
        }
        
        return Padding(
          padding: EdgeInsets.only(bottom: sh * 0.015),  
          child: _buildServiceCard(services[index], sw),  
        );
      },
    );
  }
  
  Widget _buildLoadingMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              ServiceMenuTheme.primaryPurple,
            ),
          ),
        ),
      ),
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
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ServiceMenuTheme.screenHorizontalPadding(sw)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: ServiceMenuTheme.statusError,  // Color rojo
            ),
            const SizedBox(height: 16),
            // Título del error
            Text(
              'Error al cargar servicios',
              style: TextStyle(
                fontSize: ServiceMenuTheme.cardTitleSize(sw),
                fontWeight: FontWeight.bold,
                color: ServiceMenuTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ServiceMenuTheme.cardSubtitleSize(sw),
                color: ServiceMenuTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ServiceBloc>().add(LoadServices());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ServiceMenuTheme.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildEmptyState(double sw) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ServiceMenuTheme.screenHorizontalPadding(sw)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: ServiceMenuTheme.textSecondary.withAlpha(128),  
            ),
            const SizedBox(height: 16),
            Text(
              'No hay servicios registrados',
              style: TextStyle(
                fontSize: ServiceMenuTheme.cardTitleSize(sw),
                fontWeight: FontWeight.bold,
                color: ServiceMenuTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crea tu primer servicio para comenzar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ServiceMenuTheme.cardSubtitleSize(sw),
                color: ServiceMenuTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
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
