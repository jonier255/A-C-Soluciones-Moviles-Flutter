import 'package:flutter/material.dart';
import 'admin_home_constants.dart';

/// Section with main action buttons (Técnico, Cliente)
class MainButtonsSection extends StatelessWidget {
  const MainButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          MainButton(icon: Icons.badge, label: "Técnico"),
          MainButton(icon: Icons.person, label: "Cliente"),
        ],
      ),
    );
  }
}

/// Main button with hover effect
class MainButton extends StatefulWidget {
  final IconData icon;
  final String label;

  const MainButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: 120,
        height: 90,
        decoration: BoxDecoration(
          color: _isHovered ? AdminHomeTheme.lightBlue : AdminHomeTheme.darkBlue,
          borderRadius: BorderRadius.circular(AdminHomeTheme.mainButtonRadius),
          boxShadow: [AdminHomeTheme.defaultShadow()],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: AdminHomeTheme.iconSize, color: Colors.white),
            const SizedBox(height: 5),
            Text(
              widget.label,
              style: AdminHomeTheme.buttonLabelStyle,
            ),
          ],
        ),
      ),
    );
  }
}
