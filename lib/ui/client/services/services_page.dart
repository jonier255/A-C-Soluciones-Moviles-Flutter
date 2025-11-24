import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/model/client/service_model.dart';
import 'package:flutter_a_c_soluciones/repository/client/service_api_service.dart';
import 'package:flutter_a_c_soluciones/repository/client/solicitud_api_solicitud.dart';
import 'package:flutter_a_c_soluciones/ui/client/Requests/create/create_request_modal.dart';

class ServicesContent extends StatefulWidget {
  final int clienteId;

  const ServicesContent({super.key, required this.clienteId});

  @override
  State<ServicesContent> createState() => _ServicesContentState();
}

class _ServicesContentState extends State<ServicesContent> {
  final ServiceRepository _repository = ServiceRepository();
  late Future<List<ServiceModel>> _futureServices;
  int _currentPage = 0;
  static const int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _futureServices = _repository.getServices();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;

    return Column(
      children: [
        // Header con contador de servicios
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: isTablet ? 32 : 24,
            horizontal: isTablet ? 32 : 20,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E91D8),
                Color(0xFF56AFEC),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FutureBuilder<List<ServiceModel>>(
            future: _futureServices,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Colors.white,
                        size: isTablet ? 48 : 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Error al cargar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 20 : 16,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                final servicios = snapshot.data!;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isTablet ? 16 : 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.miscellaneous_services_rounded,
                            color: Colors.white,
                            size: isTablet ? 40 : 32,
                          ),
                        ),
                        SizedBox(width: isTablet ? 16 : 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${servicios.length}',
                              style: TextStyle(
                                fontSize: isTablet ? 48 : 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Servicios Disponibles',
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    '0 Servicios',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              }
            },
          ),
        ),
        Expanded(
          child: ColoredBox(
            color: const Color(0xFFF5F7FA),
            child: FutureBuilder<List<ServiceModel>>(
              future: _futureServices,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF2E91D8),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.all(isTablet ? 32 : 20),
                      padding: EdgeInsets.all(isTablet ? 24 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: Colors.red,
                            size: isTablet ? 64 : 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Error: ${snapshot.error}",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: isTablet ? 18 : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.all(isTablet ? 32 : 20),
                      padding: EdgeInsets.all(isTablet ? 32 : 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            color: Colors.grey[400],
                            size: isTablet ? 64 : 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No hay servicios disponibles",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isTablet ? 18 : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final services = snapshot.data!;
                final totalPages = (services.length / _itemsPerPage).ceil();
                final startIndex = _currentPage * _itemsPerPage;
                final endIndex = (_currentPage + 1) * _itemsPerPage;
                final currentServices = services.sublist(
                  startIndex,
                  endIndex > services.length ? services.length : endIndex,
                );

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(isTablet ? 24 : 16),
                        itemCount: currentServices.length,
                        itemBuilder: (context, index) {
                          final service = currentServices[index];
                          return _buildServiceCard(
                            context: context,
                            service: service,
                            isTablet: isTablet,
                          );
                        },
                      ),
                    ),
                    if (totalPages > 1)
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 16 : 12,
                          horizontal: isTablet ? 24 : 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _currentPage > 0
                                    ? () {
                                        setState(() {
                                          _currentPage--;
                                        });
                                      }
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _currentPage > 0
                                        ? const Color(0xFF2E91D8)
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: _currentPage > 0
                                        ? Colors.white
                                        : Colors.grey[600],
                                    size: isTablet ? 24 : 20,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: isTablet ? 24 : 16),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20 : 16,
                                vertical: isTablet ? 12 : 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E91D8).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Página ${_currentPage + 1} de $totalPages",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isTablet ? 16 : 14,
                                  color: const Color(0xFF2E91D8),
                                ),
                              ),
                            ),
                            SizedBox(width: isTablet ? 24 : 16),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _currentPage < totalPages - 1
                                    ? () {
                                        setState(() {
                                          _currentPage++;
                                        });
                                      }
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _currentPage < totalPages - 1
                                        ? const Color(0xFF2E91D8)
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: _currentPage < totalPages - 1
                                        ? Colors.white
                                        : Colors.grey[600],
                                    size: isTablet ? 24 : 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required ServiceModel service,
    required bool isTablet,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final result = await showDialog(
              context: context,
              builder: (_) => CrearSolicitudModal(
                clienteId: widget.clienteId,
                servicio: service,
                repository: SolicitudApiRepository(),
              ),
            );
            if (result == true) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Solicitud creada con éxito',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green.shade600,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.only(
                      top: 20,
                      left: 16,
                      right: 16,
                    ),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isTablet ? 16 : 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E91D8).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.build_circle_rounded,
                    color: const Color(0xFF2E91D8),
                    size: isTablet ? 40 : 32,
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 20 : 18,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service.descripcion,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 12,
                    vertical: isTablet ? 10 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "\$${service.price}",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 18 : 16,
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
