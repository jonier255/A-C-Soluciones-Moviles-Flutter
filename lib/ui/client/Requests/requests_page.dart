import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_a_c_soluciones/model/client/solicitud_model.dart';
import 'package:flutter_a_c_soluciones/repository/client/solicitud_api_solicitud.dart';

class RequestsContent extends StatefulWidget {
  const RequestsContent({super.key});

  @override
  State<RequestsContent> createState() => _RequestsContentState();
}

class _RequestsContentState extends State<RequestsContent> {
  final SolicitudApiRepository _repository = SolicitudApiRepository();
  late Future<List<Solicitud>> _futureSolicitudes;
  int _currentPage = 0;
  static const int _itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    _futureSolicitudes = _repository.getSolicitudes();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1024;

    return Column(
      children: [
        // Header con gráfico de estado
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: isTablet ? 32 : 24,
            horizontal: isTablet ? 32 : 20,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF56AFEC),
                const Color(0xFF2E91D8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FutureBuilder<List<Solicitud>>(
            future: _futureSolicitudes,
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
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Column(
                  children: [
                    Icon(
                      Icons.request_page_rounded,
                      color: Colors.white,
                      size: isTablet ? 48 : 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sin solicitudes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 20 : 16,
                      ),
                    ),
                  ],
                );
              }

              final solicitudes = snapshot.data!;
              final pendientes = solicitudes
                  .where((s) => s.estado.trim().toLowerCase() == 'pendiente')
                  .length;
              final enProceso = solicitudes
                  .where((s) => s.estado.trim().toLowerCase() == 'en proceso')
                  .length;
              final completadas = solicitudes
                  .where((s) => s.estado.trim().toLowerCase() == 'completado')
                  .length;

              final total = pendientes + enProceso + completadas;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.request_page_rounded,
                        color: Colors.white,
                        size: isTablet ? 32 : 28,
                      ),
                      SizedBox(width: isTablet ? 12 : 8),
                      Text(
                        'Estado de las Solicitudes',
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 24 : 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Gráfico de pastel
                      Container(
                        width: isTablet ? 150 : 120,
                        height: isTablet ? 150 : 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.orange,
                                value: pendientes.toDouble(),
                                title: total > 0
                                    ? '${((pendientes / total) * 100).toStringAsFixed(0)}%'
                                    : '0%',
                                radius: isTablet ? 50 : 45,
                                titleStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 14 : 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.blue,
                                value: enProceso.toDouble(),
                                title: total > 0
                                    ? '${((enProceso / total) * 100).toStringAsFixed(0)}%'
                                    : '0%',
                                radius: isTablet ? 50 : 45,
                                titleStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 14 : 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.green,
                                value: completadas.toDouble(),
                                title: total > 0
                                    ? '${((completadas / total) * 100).toStringAsFixed(0)}%'
                                    : '0%',
                                radius: isTablet ? 50 : 45,
                                titleStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 14 : 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            sectionsSpace: 2,
                            centerSpaceRadius: isTablet ? 40 : 30,
                          ),
                        ),
                      ),
                      // Leyenda
                      Container(
                        padding: EdgeInsets.only(left: isTablet ? 32 : 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLegendItem(
                              'Pendientes',
                              pendientes,
                              Colors.orange,
                              isTablet: isTablet,
                            ),
                            SizedBox(height: isTablet ? 12 : 8),
                            _buildLegendItem(
                              'En Proceso',
                              enProceso,
                              Colors.blue,
                              isTablet: isTablet,
                            ),
                            SizedBox(height: isTablet ? 12 : 8),
                            _buildLegendItem(
                              'Completadas',
                              completadas,
                              Colors.green,
                              isTablet: isTablet,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                ],
              );
            },
          ),
        ),
        Expanded(
          child: Container(
            color: const Color(0xFFF5F7FA),
            child: FutureBuilder<List<Solicitud>>(
              future: _futureSolicitudes,
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
                            color: Colors.black.withOpacity(0.08),
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
                            color: Colors.black.withOpacity(0.08),
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
                            "No hay solicitudes disponibles",
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

                final solicitudes = snapshot.data!;
                final totalPages = (solicitudes.length / _itemsPerPage).ceil();
                final startIndex = _currentPage * _itemsPerPage;
                final endIndex = (_currentPage + 1) * _itemsPerPage;

                final currentSolicitudes = solicitudes.sublist(
                  startIndex,
                  endIndex > solicitudes.length ? solicitudes.length : endIndex,
                );

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(isTablet ? 24 : 16),
                        itemCount: currentSolicitudes.length,
                        itemBuilder: (context, index) {
                          final solicitud = currentSolicitudes[index];
                          return _buildRequestCard(
                            context: context,
                            solicitud: solicitud,
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
                              color: Colors.black.withOpacity(0.05),
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
                                color: const Color(0xFF2E91D8).withOpacity(0.1),
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

  Widget _buildLegendItem(
    String label,
    int count,
    Color color, {
    required bool isTablet,
  }) {
    return Row(
      children: [
        Container(
          width: isTablet ? 16 : 12,
          height: isTablet ? 16 : 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: isTablet ? 12 : 8),
        Text(
          '$label: $count',
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRequestCard({
    required BuildContext context,
    required Solicitud solicitud,
    required bool isTablet,
  }) {
    Color estadoColor;
    IconData estadoIcon;

    switch (solicitud.estado.toLowerCase().trim()) {
      case 'pendiente':
        estadoColor = Colors.orange;
        estadoIcon = Icons.pending_rounded;
        break;
      case 'en proceso':
        estadoColor = Colors.blue;
        estadoIcon = Icons.work_rounded;
        break;
      case 'completado':
        estadoColor = Colors.green;
        estadoIcon = Icons.check_circle_rounded;
        break;
      default:
        estadoColor = Colors.grey;
        estadoIcon = Icons.help_outline_rounded;
    }

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
                color: estadoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                estadoIcon,
                color: estadoColor,
                size: isTablet ? 40 : 32,
              ),
            ),
            SizedBox(width: isTablet ? 16 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: isTablet ? 16 : 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: isTablet ? 8 : 6),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(
                          DateTime.parse(solicitud.fechaSolicitud),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 8 : 6),
                  Text(
                    solicitud.descripcion,
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
                color: estadoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                solicitud.estado,
                style: TextStyle(
                  color: estadoColor,
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 14 : 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
