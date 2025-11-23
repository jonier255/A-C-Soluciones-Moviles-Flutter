import 'package:flutter/material.dart';
import 'admin_menu_constants.dart';

/// Tarjeta de opción moderna con gradiente y efecto ripple
class AdminOptionCard extends StatelessWidget {
  final AdminMenuOption option;
  
  const AdminOptionCard({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw > 600;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: AdminMenuTheme.cardMaxWidth(sw),
          ),
          decoration: BoxDecoration(
            gradient: option.gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              AdminMenuTheme.cardShadow(option.gradient.colors.first),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(AdminMenuTheme.cardPadding(sw)),
            child: Row(
              children: [
                _buildIcon(sw, isTablet),
                SizedBox(width: AdminMenuTheme.cardSpacing(sw)),
                Expanded(child: _buildTexts(sw, isTablet)),
                _buildArrow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Icono con fondo translúcido y bordes redondeados
  Widget _buildIcon(double sw, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(AdminMenuTheme.cardIconPadding(sw)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        option.icon,
        size: AdminMenuTheme.cardIconSize(sw),
        color: Colors.white,
      ),
    );
  }

  /// Textos: título y subtítulo
  Widget _buildTexts(double sw, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          option.title,
          style: TextStyle(
            fontSize: AdminMenuTheme.cardTitleSize(sw),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isTablet ? 8 : 6),
        Text(
          option.subtitle,
          style: TextStyle(
            fontSize: AdminMenuTheme.cardSubtitleSize(sw),
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Flecha indicadora con fondo circular
  Widget _buildArrow() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}
