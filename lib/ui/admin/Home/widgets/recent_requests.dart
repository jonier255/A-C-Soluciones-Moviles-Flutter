import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request/request_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/administrador/request/request_bloc.dart';
import '../../../../bloc/administrador/request/request_state.dart';
import '../../../../model/administrador/request_model.dart';
import 'admin_home_constants.dart';

class RecentRequestsSection extends StatelessWidget {
  const RecentRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AdminHomeTheme.horizontalPadding(sw)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: sw * 0.02, bottom: sh * 0.015),
            child: Text(
              "Solicitudes recientes",
              style: AdminHomeTheme.sectionTitleStyle(sw),
            ),
          ),
          BlocBuilder<RequestBloc, RequestState>(
            builder: (context, state) {
              if (state is RequestLoading) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(sh * 0.05),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF667eea),
                      ),
                    ),
                  ),
                );
              }
              if (state is RequestLoaded) {
                final recentRequests = state.requests.take(3).toList();
                if (recentRequests.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(sh * 0.04),
                    decoration: BoxDecoration(
                      color: AdminHomeTheme.cardBackground,
                      borderRadius: BorderRadius.circular(AdminHomeTheme.cardRadius),
                      boxShadow: AdminHomeTheme.cardShadow(),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: sw * 0.15,
                            color: AdminHomeTheme.textSecondary,
                          ),
                          SizedBox(height: sh * 0.01),
                          Text(
                            "No hay solicitudes recientes",
                            style: TextStyle(
                              fontSize: sw * 0.04,
                              color: AdminHomeTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AdminHomeTheme.cardBackground,
                        borderRadius: BorderRadius.circular(AdminHomeTheme.cardRadius),
                        boxShadow: AdminHomeTheme.cardShadow(),
                      ),
                      child: Column(
                        children: recentRequests
                            .asMap()
                            .entries
                            .map((entry) => RequestCard(
                                  request: entry.value,
                                  isLast: entry.key == recentRequests.length - 1,
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: sh * 0.015),
                    const ViewMoreButton(),
                  ],
                );
              }
              if (state is RequestError) {
                return Container(
                  padding: EdgeInsets.all(sh * 0.03),
                  decoration: BoxDecoration(
                    color: AdminHomeTheme.cardBackground,
                    borderRadius: BorderRadius.circular(AdminHomeTheme.cardRadius),
                    boxShadow: AdminHomeTheme.cardShadow(),
                  ),
                  child: Center(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: sw * 0.035,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de solicitud con diseño moderno
class RequestCard extends StatelessWidget {
  final Request request;
  final bool isLast;

  const RequestCard({
    super.key,
    required this.request,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    
    return Container(
      margin: EdgeInsets.all(sw * 0.025),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.white,
            Color(0xFFF8F9FA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(sw * 0.03),
            decoration: BoxDecoration(
              gradient: AdminHomeTheme.cardGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.build_rounded,
              color: Colors.white,
              size: AdminHomeTheme.requestCardIconSize(sw),
            ),
          ),
          SizedBox(width: sw * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.descripcion,
                  style: AdminHomeTheme.requestDescriptionStyle(sw),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: sh * 0.006),
                Text(
                  request.direccionServicio
                      .replaceAll('\n', ' ')
                      .replaceAll(RegExp(r'\s+'), ' '),
                  style: AdminHomeTheme.requestMetaStyle(sw),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: sh * 0.006),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request.fechaSolicitud.toString().split(' ')[0],
                        style: AdminHomeTheme.requestMetaStyle(sw),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sw * 0.025,
                        vertical: sh * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request.estado).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AdminHomeTheme.statusBadgeRadius),
                        border: Border.all(
                          color: _getStatusColor(request.estado),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        request.estado,
                        style: AdminHomeTheme.statusStyle(sw, _getStatusColor(request.estado)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aceptada':
      case 'completado':
      case 'finalizado':
        return AdminHomeTheme.statusCompleted;
      case 'pendiente':
      case 'en proceso':
        return AdminHomeTheme.statusPending;
      default:
        return AdminHomeTheme.textSecondary;
    }
  }
}

/// Botón para ver más solicitudes
class ViewMoreButton extends StatelessWidget {
  const ViewMoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    
    return Center(
      child: TextButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<RequestBloc>(context),
                child: const RequestScreen(),
              ),
            ),
          );
        },
        icon: Icon(
          Icons.arrow_forward_rounded,
          size: sw * 0.05,
          color: AdminHomeTheme.primaryGradientEnd,
        ),
        label: Text(
          "Ver todas las solicitudes",
          style: AdminHomeTheme.viewMoreStyle(sw),
        ),
      ),
    );
  }
}
