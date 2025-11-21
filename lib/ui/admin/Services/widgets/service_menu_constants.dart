import 'package:flutter/material.dart';

class ServiceMenuTheme {
  static const Color primaryGradientStart = Color.fromARGB(255, 57, 135, 236);
  static const Color primaryGradientEnd = Color.fromARGB(255, 15, 18, 194);
  
  static const Color createServiceGradientStart = Color.fromARGB(255, 46, 111, 231);
  static const Color createServiceGradientEnd = Color.fromARGB(255, 0, 184, 148);
  
  static const Color listServiceGradientStart = Color.fromARGB(255, 50, 30, 202);
  static const Color listServiceGradientEnd = Color.fromARGB(255, 64, 52, 238);
  
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  
  static const Color selectedNavColor = Color.fromARGB(255, 58, 88, 221);
  static const Color unselectedNavColor = Color.fromARGB(255, 149, 165, 166);
  
  static const Color primaryPurple = Color.fromARGB(255, 54, 84, 219);
  static const Color cardBorder = Color.fromARGB(255, 225, 232, 237);
  
  static const Color statusCompleted = Color(0xFF00B894);
  static const Color statusPending = Color(0xFFFDAA00);
  static const Color statusError = Color(0xFFE74C3C);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient createServiceGradient = LinearGradient(
    colors: [createServiceGradientStart, createServiceGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient listServiceGradient = LinearGradient(
    colors: [listServiceGradientStart, listServiceGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static List<BoxShadow> headerShadow() {
    return [
      BoxShadow(
        color: primaryGradientStart.withAlpha(77),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ];
  }
  
  static List<BoxShadow> logoShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ];
  }
  
  static BoxShadow cardShadow(Color gradientColor) {
    return BoxShadow(
      color: gradientColor.withOpacity(0.4),
      blurRadius: 15,
      offset: const Offset(0, 8),
    );
  }
  
  static List<BoxShadow> navBarShadow() {
    return [
      BoxShadow(
        color: Colors.black.withAlpha(26),
        blurRadius: 20,
        offset: const Offset(0, -5),
      ),
    ];
  }
  
  static double headerTitleSize(double sw) => sw > 600 ? sw * 0.05 : sw * 0.065;
  static double headerSubtitleSize(double sw) => sw > 600 ? sw * 0.027 : sw * 0.035;
  static double backButtonSize(double sw) => sw * 0.055;
  
  static double logoSize(double sw) => sw > 600 ? sw * 0.2 : sw * 0.25;
  
  static double welcomeTitleSize(double sw) => sw > 600 ? sw * 0.043 : sw * 0.055;
  static double welcomeSubtitleSize(double sw) => sw > 600 ? sw * 0.027 : sw * 0.035;
  
  static double cardPadding(double sw) => sw > 600 ? sw * 0.053 : sw * 0.06;
  static double cardIconSize(double sw) => sw > 600 ? sw * 0.08 : sw * 0.1;
  static double cardIconPadding(double sw) => sw > 600 ? sw * 0.033 : sw * 0.04;
  static double cardTitleSize(double sw) => sw > 600 ? sw * 0.033 : sw * 0.045;
  static double cardSubtitleSize(double sw) => sw > 600 ? sw * 0.025 : sw * 0.032;
  static double cardSpacing(double sw) => sw > 600 ? sw * 0.04 : sw * 0.05;
  static double cardMaxWidth(double sw) => sw > 600 ? 700 : double.infinity;
  
  static double horizontalPadding(double sw) => sw > 600 ? sw * 0.15 : sw * 0.06;
  static double screenHorizontalPadding(double sw) => sw > 600 ? sw * 0.15 : sw * 0.06;
  static double topSpacing(double sh) => sh * 0.025;
  static double logoSpacing(double sh) => sh * 0.038;
  static double welcomeSpacing(double sh) => sh * 0.044;
  static double optionSpacing(double sh) => sh * 0.025;
  static double bottomSpacing(double sh) => sh * 0.038;
  
  static BoxShadow get bottomNavShadow => BoxShadow(
        color: Colors.black.withAlpha(25),
        blurRadius: 20,
        offset: const Offset(0, -5),
      );
  static double bottomNavHorizontalPadding(double sw) => sw > 600 ? sw * 0.08 : sw * 0.05;
  static double bottomNavIconSize(double sw) => sw > 600 ? sw * 0.05 : sw * 0.065;
  static double bottomNavLabelSize(double sw) => sw > 600 ? sw * 0.022 : sw * 0.028;
}

class ServiceMenuOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback? onTap;
  
  const ServiceMenuOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.onTap,
  });
}

