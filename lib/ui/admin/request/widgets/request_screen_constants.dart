import 'package:flutter/material.dart';

/// Constants and theme configuration for Request Screen
class RequestScreenTheme {
  // Modern color palette
  static const Color primaryGradientStart = Color.fromARGB(255, 37, 71, 223);
  static const Color primaryGradientEnd = Color.fromARGB(255, 32, 42, 185);
  static const Color accentGradientStart = Color.fromARGB(255, 7, 155, 240);
  static const Color accentGradientEnd = Color.fromARGB(255, 44, 121, 189);
  static const Color cardGradientStart = Color.fromARGB(255, 53, 223, 186);
  static const Color cardGradientEnd = Color.fromARGB(255, 48, 75, 230);
  static const Color successColor = Color.fromARGB(255, 49, 145, 209);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  
  // Gradients
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
  
  static const LinearGradient cardIconGradient = LinearGradient(
    colors: [Color.fromARGB(255, 53, 175, 223), cardGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Responsive sizing functions
  static double topCurveHeight(double height) => height * 0.225;
  static double titleTop(double height) => height * 0.05;
  static double titleSidePadding(double width) => width * 0.025;
  static double titleFontSize(double width) => width * 0.06;
  static double smallGap(double height) => height * 0.02;
  
  // Container sizing
  static double containerMarginHorizontal(double width) => width * 0.09;
  static double containerMarginVertical(double height) => height * 0.025;
  static double containerInnerPadding(double width) => width * 0.02;
  
  // Card sizing
  static double listPadding(double width) => width * 0.03;
  static double cardPadding(double width) => width * 0.04;
  static double cardMarginVertical(double height) => height * 0.012;
  static double iconCircleSize(double width) => width * 0.07;
  static double iconPadding(double iconSize) => iconSize * 0.35;
  static double cardSpacing(double width) => width * 0.04;
  static double textSpacing(double height) => height * 0.005;
  
  // Pagination sizing
  static double paginationVerticalPadding(double height) => height * 0.015;
  static double paginationSpacing(double width) => width * 0.02;
  static double paginationRunSpacing(double height) => height * 0.01;
  static double pageButtonPadding(double width) => width * 0.005;
  static double pageButtonInnerPadding(double width) => width * 0.007;
  static double arrowButtonMargin(double width) => width * 0.01;
  static double arrowButtonPadding(double width) => width * 0.03;
  
  // Back button
  static double backButtonSize(double width) => width * 0.075;

  // Border radius
  static const double containerRadius = 30.0;
  static const double cardRadius = 25.0;

  // Pagination per page
  static const int requestsPerPage = 4;

  // Shadows
  static List<BoxShadow> containerShadow() {
    return [
      BoxShadow(
        color: primaryGradientEnd.withValues(alpha: 0.3),
        spreadRadius: 0,
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ];
  }

  static List<BoxShadow> cardShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        spreadRadius: 0,
        blurRadius: 15,
        offset: const Offset(0, 4),
      ),
    ];
  }

  static List<BoxShadow> iconShadow() {
    return [
      BoxShadow(
        color: const Color.fromARGB(255, 104, 171, 230).withValues(alpha: 0.3),
        spreadRadius: 0,
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }
  
  static List<BoxShadow> buttonShadow() {
    return [
      BoxShadow(
        color: primaryGradientStart.withValues(alpha: 0.4),
        spreadRadius: 0,
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ];
  }

  // Text styles
  static const TextStyle headerTitleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static const TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.w600,
    color: Color(0xFF6C757D),
    fontSize: 13,
  );

  static const TextStyle valueStyle = TextStyle(
    fontWeight: FontWeight.w500,
    color: Color(0xFF2D3436),
    fontSize: 14,
  );

  static const TextStyle emptyMessageStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF95A5A6),
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2D3436),
  );
}
