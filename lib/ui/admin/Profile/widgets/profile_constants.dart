import 'package:flutter/material.dart';

/// Constantes y tema para la pantalla de edición de perfil de administrador
class ProfileTheme {
  // Colores
  static const Color primaryBlue = Color(0xFF007BFF);
  static const Color tealAccent = Colors.teal;
  static const Color backgroundColor = Colors.white;
  static const Color textColorPrimary = Colors.black87;
  static const Color textColorSecondary = Colors.white70;
  
  // Dimensiones del encabezado
  static const double headerHeight = 120.0;
  static const double headerBorderRadius = 20.0;
  static const double logoHeight = 40.0;
  
  // Avatar
  static const double avatarRadius = 46.0;
  static const double avatarPadding = 4.0;
  static const double avatarOffset = -40.0;
  static const double avatarFontSize = 36.0;
  
  // Formulario
  static const double formMaxWidth = 700.0;
  static const double formPadding = 20.0;
  static const double formVerticalPadding = 18.0;
  static const double formBorderRadius = 14.0;
  static const double fieldSpacing = 14.0;
  static const double buttonSpacing = 12.0;
  
  // Texto
  static const double titleFontSize = 22.0;
  static const double subtitleFontSize = 14.0;
  static const double sectionTitleFontSize = 20.0;
  
  // Espaciado
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 14.0;
  static const double spacingLarge = 25.0;
  
  // Gradiente del encabezado
  static const Gradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, tealAccent],
  );
  
  // Sombras
  static List<BoxShadow> cardShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ];
  }
  
  static List<BoxShadow> avatarShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.12),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ];
  }
  
  // Estilos de texto
  static const TextStyle titleStyle = TextStyle(
    fontSize: titleFontSize,
    color: backgroundColor,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: subtitleFontSize,
    color: textColorSecondary,
  );
  
  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: sectionTitleFontSize,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle avatarTextStyle = TextStyle(
    fontSize: avatarFontSize,
    color: backgroundColor,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle buttonTextStyle = TextStyle(
    color: backgroundColor,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle cancelButtonTextStyle = TextStyle(
    color: textColorPrimary,
    fontWeight: FontWeight.w600,
  );
}
