import 'package:flutter/material.dart';

/// Constants and theme configuration for Request Screen
class RequestScreenTheme {
  // Colors
  static const Color primaryBlue = Color.fromARGB(255, 46, 145, 216);
  static const Color purpleAccent = Color.fromARGB(255, 179, 46, 241);
  static const Color lightBlue = Color.fromARGB(255, 156, 204, 243);
  static const Color backgroundColor = Colors.white;

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
        color: purpleAccent.withOpacity(0.9),
        spreadRadius: 4,
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static List<BoxShadow> iconShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ];
  }

  // Text styles
  static const TextStyle headerTitleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle valueStyle = TextStyle(
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static const TextStyle emptyMessageStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );
}
