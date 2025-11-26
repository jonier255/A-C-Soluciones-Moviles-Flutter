import 'package:flutter/material.dart';
import '../../../../model/administrador/request_model.dart';
import 'request_screen_constants.dart';

/// Card displaying a single request
class RequestCard extends StatelessWidget {
  final Request request;

  const RequestCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;
    final cardPadding = sw * 0.04;
    final cardMarginVertical = sh * 0.01;
    final iconCircleSize = sw * 0.12;
    final cardSpacing = sw * 0.03;
    final textSpacing = sh * 0.008;

    return Container(
      margin: EdgeInsets.symmetric(vertical: cardMarginVertical),
      decoration: BoxDecoration(
        color: RequestScreenTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: RequestScreenTheme.cardShadow(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Future: Navigate to request details
            },
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIcon(iconCircleSize, sw),
                  SizedBox(width: cardSpacing),
                  Expanded(
                    child: _buildRequestInfo(textSpacing, sw),
                  ),
                  _buildStatusBadge(sw),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(double iconSize, double sw) {
    return Container(
      padding: EdgeInsets.all(sw * 0.025),
      decoration: BoxDecoration(
        gradient: RequestScreenTheme.accentGradient,
        boxShadow: RequestScreenTheme.iconShadow(),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.description_rounded,
        size: iconSize * 0.5,
        color: Colors.white,
      ),
    );
  }
  
  Widget _buildStatusBadge(double sw) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: sw * 0.025, vertical: sw * 0.015),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00d2a0), Color(0xFF00b894)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Activo',
        style: TextStyle(
          color: Colors.white,
          fontSize: sw * 0.028,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRequestInfo(double spacing, double sw) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          request.descripcion,
          style: TextStyle(
            fontSize: sw * 0.04,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: spacing + 6),
        _buildInfoRow(Icons.location_on_outlined, request.direccionServicio, sw),
        SizedBox(height: spacing + 4),
        _buildInfoRow(
          Icons.calendar_today_outlined,
          request.fechaSolicitud.toIso8601String().split("T").first,
          sw,
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String value, double sw) {
    return Row(
      children: [
        Icon(
          icon,
          size: sw * 0.035,
          color: const Color(0xFF95A5A6),
        ),
        SizedBox(width: sw * 0.015),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2D3436),
              fontSize: sw * 0.035,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
