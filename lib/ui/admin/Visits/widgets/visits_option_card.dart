import 'package:flutter/material.dart';
import 'visits_menu_constants.dart';

/// Tarjeta de opción moderna con gradiente, ícono y textos
class VisitsOptionCard extends StatelessWidget {
  final MenuOption option;
  final VoidCallback onTap;

  const VisitsOptionCard({
    super.key,
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: option.gradientColors[1].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: sh * 0.025,
              horizontal: sw * 0.05,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: option.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildIcon(sw),
                SizedBox(width: sw * 0.04),
                _buildTexts(sw, sh),
                _buildArrow(sw),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Ícono circular con fondo blanco semitransparente
  Widget _buildIcon(double sw) {
    return Container(
      padding: EdgeInsets.all(sw * 0.035),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
      child: Icon(
        option.icon,
        size: sw * 0.1,
        color: Colors.white,
      ),
    );
  }

  /// Textos del título y subtítulo
  Widget _buildTexts(double sw, double sh) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            option.title,
            style: TextStyle(
              fontSize: sw * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: sh * 0.005),
          Text(
            option.subtitle,
            style: TextStyle(
              fontSize: sw * 0.032,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// Flecha indicadora
  Widget _buildArrow(double sw) {
    return Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white.withOpacity(0.8),
      size: sw * 0.05,
    );
  }
}
