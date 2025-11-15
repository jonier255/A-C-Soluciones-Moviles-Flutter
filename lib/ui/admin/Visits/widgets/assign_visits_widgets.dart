import 'package:flutter/material.dart';
import 'assign_visits_constants.dart';

/// Contenedor decorativo para campos de formulario
class FieldContainer extends StatelessWidget {
  final Widget child;

  const FieldContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Decoración de input estándar para todos los campos
InputDecoration buildInputDecoration(
  BuildContext context,
  String label, {
  IconData? icon,
}) {
  final size = MediaQuery.of(context).size;
  return InputDecoration(
    prefixIcon: icon != null
        ? Icon(icon, color: AssignVisitsTheme.accentBlue)
        : null,
    labelText: label,
    labelStyle: const TextStyle(color: Colors.black),
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(
      vertical: AssignVisitsTheme.inputVerticalPadding(size.height),
      horizontal: AssignVisitsTheme.inputHorizontalPadding(size.width),
    ),
  );
}

/// Título de sección con estilo consistente
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AssignVisitsTheme.accentBlue,
      ),
    );
  }
}
