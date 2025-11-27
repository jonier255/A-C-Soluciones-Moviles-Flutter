import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final double elevation;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? shadowColor;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
    this.elevation = 6,
    this.borderRadius = 16,
    this.onTap,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      color: color,
      elevation: elevation,
      // ignore: deprecated_member_use
      shadowColor: shadowColor ?? const Color(0xFF2E91D8).withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    return card;
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final EdgeInsets padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final container = Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: gradient.colors.first.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: container,
        ),
      );
    }

    return container;
  }
}
