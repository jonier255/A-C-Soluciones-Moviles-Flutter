import 'package:flutter/material.dart';

/// Constantes y configuración de tema para el menú de visitas
class VisitsMenuTheme {
  // Paleta de colores moderna
  static const Color primaryGradientStart = Color(0xFF667eea);
  static const Color primaryGradientEnd = Color(0xFF764ba2);
  static const Color accentGradientStart = Color(0xFFf093fb);
  static const Color accentGradientEnd = Color(0xFF4facfe);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color selectedNavColor = Color(0xFF764ba2);
  static const Color unselectedNavColor = Color(0xFF95A5A6);
  
  // Gradientes predefinidos
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentGradientStart, accentGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Sombras
  static List<BoxShadow> containerShadow() {
    return [
      BoxShadow(
        color: primaryGradientEnd.withOpacity(0.2),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ];
  }
  
  static List<BoxShadow> navBarShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, -5),
      ),
    ];
  }
  
  // Dimensiones responsivas
  static double headerHeight(double sh) => sh * 0.22;
  static double logoHeight(double sh) => sh * 0.15;
  static double headerTopPosition(double sh) => sh * 0.05;
  static double backButtonSize(double sw) => sw * 0.06;
  static double titleFontSize(double sw) => sw * 0.06;
  static double decorativeLineWidth(double sw) => sw * 0.12;
  
  // Espaciado
  static double contentPaddingH(double sw) => sw * 0.05;
  static double topSpacing(double sh) => sh * 0.03;
  static double logoSpacing(double sh) => sh * 0.04;
  static double cardPaddingV(double sh) => sh * 0.03;
  static double cardPaddingH(double sw) => sw * 0.04;
  static double optionSpacing(double sh) => sh * 0.025;
  static double bottomSpacing(double sh) => sh * 0.03;
}

/// Configuración de opciones del menú
class MenuOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  
  const MenuOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
  });
}

/// Opciones disponibles en el menú
class VisitsMenuOptions {
  static const MenuOption assignVisits = MenuOption(
    title: "Asignar Visitas",
    subtitle: "Crear y programar nuevas visitas",
    icon: Icons.add_task_rounded,
    gradientColors: [Color(0xFFf093fb), Color(0xFF4facfe)],
  );
  
  static const MenuOption listVisits = MenuOption(
    title: "Lista de Visitas",
    subtitle: "Ver y gestionar todas las visitas",
    icon: Icons.event_note_rounded,
    gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
  );
}
