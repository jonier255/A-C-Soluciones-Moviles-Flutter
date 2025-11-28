import 'package:flutter/material.dart';

class TecnicoMenuTheme {
  static const Color primaryGradientStart = Color.fromARGB(255, 30, 118, 233);
  static const Color primaryGradientEnd = Color.fromARGB(255, 64, 169, 240);
  static const Color createTecnicoGradientStart = Color.fromARGB(255, 49, 94, 243);
  static const Color createTecnicoGradientEnd = Color.fromARGB(255, 10, 164, 235);
  static const Color listTecnicoGradientStart = Color(0xFF4A90E2);
  static const Color listTecnicoGradientEnd = Color(0xFF50C9E9);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color textPrimary = Color.fromARGB(255, 0, 0, 0);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color selectedNavColor = Color.fromARGB(255, 22, 6, 245);
  static const Color unselectedNavColor = Color(0xFF95A5A6);
  
  // Gradientes predefinidos
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient createTecnicoGradient = LinearGradient(
    colors: [createTecnicoGradientStart, createTecnicoGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient listTecnicoGradient = LinearGradient(
    colors: [listTecnicoGradientStart, listTecnicoGradientEnd],
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
  static double welcomeSpacing(double sh) => sh * 0.045;
  static double optionSpacing(double sh) => sh * 0.025;
  static double bottomSpacing(double sh) => sh * 0.05;
  
  // Border Radius
  static const double cardBorderRadius = 20;
  static const double iconContainerBorderRadius = 16;
}


class TecnicoMenuOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;
  
  const TecnicoMenuOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}
