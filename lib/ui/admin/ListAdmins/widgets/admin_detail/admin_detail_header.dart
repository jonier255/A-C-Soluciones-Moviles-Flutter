import 'package:flutter/material.dart';
import 'admin_detail_constants.dart';

/// Header con gradiente y decoración para la pantalla de detalle
class AdminDetailHeader extends StatelessWidget {
  const AdminDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isTablet = sw > 600;
    
    return Container(
      height: AdminDetailTheme.headerHeight(sh, isTablet),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AdminDetailTheme.headerGradient,
      ),
      child: Stack(
        children: [
          _buildDecorativeCircle(sw, isTop: true),
          _buildDecorativeCircle(sw, isTop: false),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.04,
                vertical: sh * 0.015,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(context, sw, isTablet),
                  const Spacer(),
                  _buildHeaderContent(sw, sh, isTablet),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Círculo decorativo
  Widget _buildDecorativeCircle(double sw, {required bool isTop}) {
    return Positioned(
      top: isTop ? -sw * 0.15 : null,
      right: isTop ? -sw * 0.15 : null,
      bottom: isTop ? null : -sw * 0.1,
      left: isTop ? null : -sw * 0.1,
      child: Container(
        width: sw * (isTop ? 0.5 : 0.4),
        height: sw * (isTop ? 0.5 : 0.4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.08),
        ),
      ),
    );
  }

  /// Botón de retroceso
  Widget _buildBackButton(BuildContext context, double sw, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: AdminDetailTheme.backButtonSize(sw, isTablet),
        ),
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.all(sw * 0.02),
      ),
    );
  }

  /// Contenido del header (ícono y título)
  Widget _buildHeaderContent(double sw, double sh, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.admin_panel_settings_rounded,
          color: Colors.white,
          size: AdminDetailTheme.headerIconSize(sw, isTablet),
        ),
        SizedBox(height: sh * 0.01),
        Text(
          'Perfil de Administrador',
          style: TextStyle(
            fontSize: AdminDetailTheme.headerTitleSize(sw, isTablet),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: sh * 0.005),
      ],
    );
  }
}
