import 'package:flutter/material.dart';

/// Constants and theme configuration for Admin Home screen
class AdminHomeTheme {
  // Colores modernos con gradientes
  static const Color primaryGradientStart = Color.fromARGB(255, 45, 78, 224);
  static const Color primaryGradientEnd = Color.fromARGB(255, 29, 26, 190);
  static const Color accentGradientStart = Color.fromARGB(255, 11, 176, 226);
  static const Color accentGradientEnd = Color(0xFF4facfe);
  static const Color cardGradientStart = Color.fromARGB(255, 30, 12, 170);
  static const Color cardGradientEnd = Color.fromARGB(255, 56, 47, 187);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color statusPending = Color.fromARGB(255, 196, 121, 10);
  static const Color statusCompleted = Color.fromARGB(255, 67, 192, 10);
  
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
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [cardGradientStart, cardGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradientes para botones principales
  static const LinearGradient technicoGradient = LinearGradient(
    colors: [Color.fromARGB(255, 54, 86, 230), Color.fromARGB(255, 27, 25, 182)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient clienteGradient = LinearGradient(
    colors: [Color.fromARGB(255, 24, 130, 218), Color(0xFF4facfe)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dimensiones responsivas
  static double waveHeaderHeight(double sh) => sh * 0.22;
  static double logoHeight(double sh) => sh * 0.12;
  
  // Dimensiones de botones principales
  static double mainButtonWidth(double sw) => sw * 0.35;
  static double mainButtonHeight(double sh) => sh * 0.11;
  static double mainButtonIconSize(double sw) => sw * 0.1;
  static double mainButtonTextSize(double sw) => sw * 0.035;
  
  // Dimensiones de botones rápidos
  static double quickButtonHeight(double sh) => sh * 0.095;
  static double quickButtonIconSize(double sw) => sw * 0.045;
  static double quickButtonTextSize(double sw) => sw * 0.028;
  
  // Dimensiones de tarjetas de solicitudes
  static double requestCardIconSize(double sw) => sw * 0.08;
  static double requestTitleSize(double sw) => sw * 0.038;
  static double requestMetaSize(double sw) => sw * 0.03;
  
  // Espaciado
  static double horizontalPadding(double sw) => sw * 0.045;
  static double sectionSpacing(double sh) => sh * 0.025;
  static double buttonSpacing(double sw) => sw * 0.025;
  
  // Border radius
  static const double mainButtonRadius = 20.0;
  static const double quickButtonRadius = 15.0;
  static const double cardRadius = 20.0;
  static const double statusBadgeRadius = 12.0;

  // Sombras elegantes
  static List<BoxShadow> cardShadow() {
    return [
      BoxShadow(
        color: primaryGradientEnd.withOpacity(0.3),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ];
  }
  
  static List<BoxShadow> buttonShadow(Color color) {
    return [
      BoxShadow(
        color: color.withOpacity(0.4),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ];
  }
  
  static List<BoxShadow> quickButtonShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }
  
  static List<BoxShadow> headerShadow() {
    return [
      BoxShadow(
        color: primaryGradientStart.withOpacity(0.3),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ];
  }

  // Estilos de texto
  static TextStyle sectionTitleStyle(double sw) => TextStyle(
    fontSize: sw * 0.05,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: 0.5,
  );
  
  static TextStyle buttonLabelStyle(double sw) => TextStyle(
    fontSize: sw * 0.04,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
  
  static TextStyle requestDescriptionStyle(double sw) => TextStyle(
    fontSize: sw * 0.038,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static TextStyle requestMetaStyle(double sw) => TextStyle(
    fontSize: sw * 0.03,
    color: textSecondary,
  );
  
  static TextStyle statusStyle(double sw, Color color) => TextStyle(
    fontSize: sw * 0.032,
    fontWeight: FontWeight.bold,
    color: color,
  );
  
  static TextStyle viewMoreStyle(double sw) => TextStyle(
    fontSize: sw * 0.04,
    fontWeight: FontWeight.w600,
    color: primaryGradientEnd,
  );
}
