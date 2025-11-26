import 'package:flutter/material.dart';

/// Constantes de tema para la pantalla de asignar visitas
class AssignVisitsTheme {
  static const Color accentBlue = Color(0xFF3875F7);
  static const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const Color cardColor = Colors.white;
  
  static double pagePadding(double width) => width * 0.05;
  static double smallGap(double height) => height * 0.015;
  static double mediumGap(double height) => height * 0.025;
  static double largeGap(double height) => height * 0.04;
  
  static double buttonVerticalPadding(double height) => height * 0.018;
  static double buttonHorizontalPadding(double width) => width * 0.04;
  static double buttonSpacing(double width) => width * 0.03;
  
  static double inputVerticalPadding(double height) => height * 0.018;
  static double inputHorizontalPadding(double width) => width * 0.03;
}
