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
    final cardPadding = RequestScreenTheme.cardPadding(size.width);
    final cardMarginVertical = RequestScreenTheme.cardMarginVertical(size.height);
    final iconCircleSize = RequestScreenTheme.iconCircleSize(size.width);
    final iconPadding = RequestScreenTheme.iconPadding(iconCircleSize);
    final cardSpacing = RequestScreenTheme.cardSpacing(size.width);
    final textSpacing = RequestScreenTheme.textSpacing(size.height);

    return Center(
      child: Card(
        color: RequestScreenTheme.backgroundColor,
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: cardMarginVertical),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RequestScreenTheme.cardRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(iconCircleSize, iconPadding),
              SizedBox(width: cardSpacing),
              Expanded(
                child: _buildRequestInfo(textSpacing),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(double iconSize, double padding) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        boxShadow: RequestScreenTheme.iconShadow(),
        color: RequestScreenTheme.backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.assignment,
        size: iconSize,
      ),
    );
  }

  Widget _buildRequestInfo(double spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("Descripción: ", request.descripcion),
        SizedBox(height: spacing),
        _buildInfoRow("Dirección: ", request.direccionServicio),
        SizedBox(height: spacing),
        _buildInfoRow(
          "Fecha solicitud: ",
          request.fechaSolicitud.toIso8601String().split("T").first,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        text: label,
        style: RequestScreenTheme.labelStyle,
        children: [
          TextSpan(
            text: value,
            style: RequestScreenTheme.valueStyle,
          ),
        ],
      ),
    );
  }
}
