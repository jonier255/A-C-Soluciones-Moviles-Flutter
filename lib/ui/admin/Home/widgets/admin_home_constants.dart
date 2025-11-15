import 'package:flutter/material.dart';

/// Constants and theme configuration for Admin Home screen
class AdminHomeTheme {
  // Colors
  static const Color primaryBlue = Color.fromARGB(255, 46, 145, 216);
  static const Color darkBlue = Color.fromARGB(255, 17, 115, 196);
  static const Color lightBlue = Color.fromARGB(255, 33, 150, 243);
  static const Color accentBlue = Color.fromARGB(255, 5, 162, 235);
  static const Color lightGray = Color(0xFFF0F2F5);
  static const Color backgroundColor = Colors.white;

  // Wave header
  static const double waveHeaderHeight = 170.0;
  static const double logoHeight = 120.0;

  // Spacing
  static const double sectionSpacing = 20.0;
  static const double cardPadding = 16.0;
  static const double buttonSpacing = 12.0;
  static const double iconSize = 50.0;
  static const double smallIconSize = 20.0;
  static const double quickButtonIconSize = 30.0;

  // Border radius
  static const double mainButtonRadius = 22.0;
  static const double quickButtonRadius = 12.0;
  static const double cardRadius = 30.0;
  static const double smallCardRadius = 35.0;

  // Shadows
  static BoxShadow defaultShadow({double opacity = 0.5}) {
    return BoxShadow(
      color: Colors.black.withOpacity(opacity),
      spreadRadius: 1,
      blurRadius: 8,
      offset: const Offset(0, 4),
    );
  }

  static BoxShadow lightShadow() {
    return BoxShadow(
      color: Colors.black.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 5,
      offset: const Offset(0, 2),
    );
  }

  static BoxShadow blueShadow() {
    return BoxShadow(
      color: Colors.blue.withOpacity(0.9),
      spreadRadius: 4,
      blurRadius: 12,
      offset: const Offset(0, 3),
    );
  }

  static List<Shadow> textShadow({Color? color, double opacity = 0.5}) {
    return [
      Shadow(
        blurRadius: 4.0,
        color: (color ?? Colors.black).withOpacity(opacity),
        offset: const Offset(1.0, 1.0),
      ),
    ];
  }

  // Text styles
  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );

  static const TextStyle buttonLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle requestDescriptionStyle = TextStyle(fontSize: 14);
  
  static const TextStyle requestMetaStyle = TextStyle(
    color: Colors.grey,
    fontSize: 12,
  );

  static const TextStyle statusStyle = TextStyle(
    color: Colors.green,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
}
