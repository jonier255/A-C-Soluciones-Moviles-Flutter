import 'package:flutter/material.dart';

/// Constants and theme configuration for Admin List Screen
class AdminListTheme {
  // Colors
  static const Color primaryBlue = Color.fromARGB(255, 46, 145, 216);
  static const Color greenAccent = Color.fromARGB(255, 34, 47, 233);
  static const Color lightBlue = Color.fromARGB(255, 89, 171, 238);
  static const Color backgroundColor = Colors.white;

  // Header
  static const double headerHeight = 180.0;
  static const double headerTitleTop = 40.0;
  static const double headerSidePadding = 10.0;
  static const double headerTitleSize = 24.0;
  static const double backButtonSize = 30.0;

  // Container
  static const double containerMarginHorizontal = 35.0;
  static const double containerMarginVertical = 20.0;
  static const double containerInnerPadding = 8.0;
  static const double containerRadius = 30.0;

  // List & Cards
  static const double listPadding = 12.0;
  static const double cardMarginVertical = 10.0;
  static const double cardPadding = 16.0;
  static const double cardRadius = 25.0;
  static const double iconContainerPadding = 12.0;
  static const double iconSize = 28.0;
  static const double cardSpacing = 16.0;
  static const double textSpacing = 4.0;

  // Pagination
  static const int adminsPerPage = 4;
  static const double paginationVerticalPadding = 12.0;
  static const double pageButtonPadding = 2.0;
  static const double pageButtonInnerPadding = 3.0;
  static const double arrowButtonMargin = 4.0;
  static const double arrowButtonPadding = 12.0;

  // Layout spacing
  static const double contentTopPadding = 180.0;
  static const double contentTopGap = 16.0;

  // Shadows
  static List<BoxShadow> containerShadow() {
    return [
      BoxShadow(
        color: greenAccent.withOpacity(0.9),
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
    fontSize: headerTitleSize,
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

  static const TextStyle arrowButtonTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );
}
