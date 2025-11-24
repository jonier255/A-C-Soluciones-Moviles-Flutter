import 'package:flutter/material.dart';

/// Constantes y configuración de tema para la pantalla de detalle de administrador
class AdminDetailTheme {
  // Colores
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color primaryGradientStart = Color.fromARGB(255, 17, 28, 182);
  static const Color primaryGradientEnd = Color.fromARGB(255, 17, 28, 182);
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF95A5A6);
  static const Color statusGreen = Color(0xFF00D2A0);
  static const Color deleteRed = Color(0xFFE74C3C);
  
  // Gradientes para header
  static const LinearGradient headerGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradientes para avatar
  static const LinearGradient avatarGradient = LinearGradient(
    colors: [Color.fromARGB(255, 20, 39, 212), Color.fromARGB(255, 17, 28, 182)],
  );
  
  // Gradientes para info cards
  static const LinearGradient cedulaGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
  );
  
  static const LinearGradient correoGradient = LinearGradient(
    colors: [Color(0xFF0984E3), Color(0xFF74B9FF)],
  );
  
  static const LinearGradient nombreGradient = LinearGradient(
    colors: [Color(0xFFE17055), Color(0xFFFAB1A0)],
  );
  
  static const LinearGradient apellidoGradient = LinearGradient(
    colors: [Color(0xFFFD79A8), Color(0xFFFFCCCC)],
  );
  
  static const LinearGradient editButtonGradient = LinearGradient(
    colors: [Color.fromARGB(255, 39, 77, 202), Color.fromARGB(255, 39, 77, 202)],
  );
  
  static const LinearGradient statusGradient = LinearGradient(
    colors: [Color(0xFF00D2A0), Color(0xFF00B894)],
  );
  
  // Dimensiones responsivas - Header
  static double headerHeight(double sh, bool isTablet) => sh * (isTablet ? 0.22 : 0.20);
  static double backButtonSize(double sw, bool isTablet) => sw * (isTablet ? 0.04 : 0.06);
  static double headerIconSize(double sw, bool isTablet) => sw * (isTablet ? 0.06 : 0.09);
  static double headerTitleSize(double sw, bool isTablet) => sw * (isTablet ? 0.045 : 0.065);
  
  // Dimensiones responsivas - Avatar
  static double avatarSize(double sw, bool isTablet) => sw * (isTablet ? 0.18 : 0.25);
  static double avatarTextSize(double avatarSize) => avatarSize * 0.35;
  
  // Dimensiones responsivas - Profile
  static double nameFontSize(double sw, bool isTablet) => sw * (isTablet ? 0.04 : 0.055);
  static double rolFontSize(double sw, bool isTablet) => sw * (isTablet ? 0.025 : 0.035);
  static double rolIconSize(double sw, bool isTablet) => sw * (isTablet ? 0.025 : 0.035);
  
  // Dimensiones responsivas - Info Cards
  static double cardIconSize(double sw, bool isTablet) => sw * (isTablet ? 0.045 : 0.065);
  static double cardPadding(double sw, bool isTablet) => sw * (isTablet ? 0.035 : 0.03);
  static double cardTitleSize(double sw, bool isTablet) => sw * (isTablet ? 0.02 : 0.028);
  static double cardValueSize(double sw, bool isTablet) => sw * (isTablet ? 0.025 : 0.035);
  
  // Dimensiones responsivas - Action Buttons
  static double buttonHeight(double sh, bool isTablet) => sh * (isTablet ? 0.075 : 0.065);
  static double buttonIconSize(double sw, bool isTablet) => sw * (isTablet ? 0.035 : 0.055);
  static double buttonTextSize(double sw, bool isTablet) => sw * (isTablet ? 0.025 : 0.035);
  
  // Espaciado
  static double sectionSpacing(double sh) => sh * 0.03;
  static double cardSpacing(double sh) => sh * 0.015;
  static double horizontalPadding(double sw) => sw * 0.04;
  
  // Sombras
  static List<BoxShadow> avatarShadow() {
    return [
      BoxShadow(
        color: const Color.fromARGB(255, 20, 39, 212).withValues(alpha: 0.4),
        blurRadius: 25,
        offset: const Offset(0, 12),
        spreadRadius: 2,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ];
  }
  
  static List<BoxShadow> cardShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }
  
  static BoxShadow buttonShadow(Color color, {bool isOutlined = false}) {
    return BoxShadow(
      color: color.withValues(alpha: isOutlined ? 0.1 : 0.3),
      blurRadius: 10,
      offset: const Offset(0, 4),
    );
  }
}
