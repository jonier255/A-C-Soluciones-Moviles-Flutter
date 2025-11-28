import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final bool isLoading;
  final double borderRadius;
  final EdgeInsets padding;
  final double? width;
  final double elevation;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF2E91D8),
    this.textColor = Colors.white,
    this.icon,
    this.isLoading = false,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    this.width,
    this.elevation = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: icon != null
          ? ElevatedButton.icon(
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(icon, color: textColor),
              style: _buttonStyle(),
              onPressed: isLoading ? null : onPressed,
              label: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            )
          : ElevatedButton(
              style: _buttonStyle(),
              onPressed: isLoading ? null : onPressed,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
            ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      elevation: elevation,
    );
  }
}

class CustomGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Gradient gradient;
  final Color textColor;
  final IconData? icon;
  final bool isLoading;
  final double borderRadius;
  final EdgeInsets padding;
  final double? width;

  const CustomGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.gradient,
    this.textColor = Colors.white,
    this.icon,
    this.isLoading = false,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
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
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: textColor),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
