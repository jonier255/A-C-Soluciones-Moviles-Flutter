import 'package:flutter/material.dart';
import 'tecnico_menu_constants.dart';

/// Tarjeta de opción con gradiente para el menú de técnicos
class TecnicoOptionCard extends StatelessWidget {
  final TecnicoMenuOption option;

  const TecnicoOptionCard({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: TecnicoMenuTheme.cardMaxWidth(sw),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: option.onTap,
            borderRadius: BorderRadius.circular(TecnicoMenuTheme.cardBorderRadius),
            child: Container(
              padding: EdgeInsets.all(TecnicoMenuTheme.cardPadding(sw)),
              decoration: BoxDecoration(
                gradient: option.gradient,
                borderRadius: BorderRadius.circular(TecnicoMenuTheme.cardBorderRadius),
                boxShadow: [
                  TecnicoMenuTheme.cardShadow(option.gradient.colors.first),
                ],
              ),
              child: Row(
                children: [
                  _buildIcon(sw),
                  SizedBox(width: TecnicoMenuTheme.cardSpacing(sw)),
                  Expanded(
                    child: _buildText(sw),
                  ),
                  _buildArrow(sw),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(double sw) {
    return Container(
      padding: EdgeInsets.all(TecnicoMenuTheme.cardIconPadding(sw)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(TecnicoMenuTheme.iconContainerBorderRadius),
      ),
      child: Icon(
        option.icon,
        size: TecnicoMenuTheme.cardIconSize(sw),
        color: Colors.white,
      ),
    );
  }

  Widget _buildText(double sw) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          option.title,
          style: TextStyle(
            fontSize: TecnicoMenuTheme.cardTitleSize(sw),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          option.subtitle,
          style: TextStyle(
            fontSize: TecnicoMenuTheme.cardSubtitleSize(sw),
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildArrow(double sw) {
    return Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
      size: TecnicoMenuTheme.cardIconSize(sw) * 0.4,
    );
  }
}
