import 'package:flutter/material.dart';

/// Constantes y configuración de tema para el menú de administradores
class AdminMenuTheme {
  // Paleta de colores moderna
  static const Color primaryGradientStart = Color(0xFF2E91D8);
  static const Color primaryGradientEnd = Color(0xFF1E6BB8);
  static const Color createAdminGradientStart = Color.fromARGB(255, 25, 146, 216);
  static const Color createAdminGradientEnd = Color.fromARGB(255, 29, 49, 226);
  static const Color listAdminGradientStart = Color.fromARGB(255, 60, 36, 240);
  static const Color listAdminGradientEnd = Color.fromARGB(255, 35, 119, 230);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color selectedNavColor = Color(0xFF2E91D8);
  static const Color unselectedNavColor = Color(0xFF95A5A6);
  
  // Gradientes predefinidos
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient createAdminGradient = LinearGradient(
    colors: [createAdminGradientStart, createAdminGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient listAdminGradient = LinearGradient(
    colors: [listAdminGradientStart, Color.fromARGB(255, 22, 158, 236)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Sombras
  static List<BoxShadow> headerShadow() {
    return [
      BoxShadow(
        color: primaryGradientStart.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ];
  }
  
  static List<BoxShadow> logoShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ];
  }
  
  static BoxShadow cardShadow(Color gradientColor) {
    return BoxShadow(
      color: gradientColor.withValues(alpha: 0.4),
      blurRadius: 15,
      offset: const Offset(0, 8),
    );
  }
  
  static List<BoxShadow> navBarShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 20,
        offset: const Offset(0, -5),
      ),
    ];
  }
  
  // Dimensiones responsivas - Header
  static double headerTitleSize(double sw) => sw > 600 ? sw * 0.05 : sw * 0.065;
  static double headerSubtitleSize(double sw) => sw > 600 ? sw * 0.027 : sw * 0.035;
  static double backButtonSize(double sw) => sw * 0.055;
  
  // Dimensiones responsivas - Logo
  static double logoSize(double sw) => sw > 600 ? sw * 0.2 : sw * 0.25;
  
  // Dimensiones responsivas - Textos
  static double welcomeTitleSize(double sw) => sw > 600 ? sw * 0.043 : sw * 0.055;
  static double welcomeSubtitleSize(double sw) => sw > 600 ? sw * 0.027 : sw * 0.035;
  
  // Dimensiones responsivas - Card
  static double cardPadding(double sw) => sw > 600 ? sw * 0.053 : sw * 0.06;
  static double cardIconSize(double sw) => sw > 600 ? sw * 0.08 : sw * 0.1;
  static double cardIconPadding(double sw) => sw > 600 ? sw * 0.033 : sw * 0.04;
  static double cardTitleSize(double sw) => sw > 600 ? sw * 0.033 : sw * 0.045;
  static double cardSubtitleSize(double sw) => sw > 600 ? sw * 0.025 : sw * 0.032;
  static double cardSpacing(double sw) => sw > 600 ? sw * 0.04 : sw * 0.05;
  static double cardMaxWidth(double sw) => sw > 600 ? 700 : double.infinity;
  
  // Espaciado
  static double horizontalPadding(double sw) => sw > 600 ? sw * 0.15 : sw * 0.06;
  static double topSpacing(double sh) => sh * 0.025;
  static double logoSpacing(double sh) => sh * 0.038;
  static double welcomeSpacing(double sh) => sh * 0.044;
  static double optionSpacing(double sh) => sh * 0.025;
  static double bottomSpacing(double sh) => sh * 0.038;
}

/// Configuración de opciones del menú
class AdminMenuOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback? onTap;
  
  const AdminMenuOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.onTap,
  });
}
