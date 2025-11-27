import 'package:flutter/material.dart';
import 'tecnico_menu_constants.dart';

/// Barra de navegación inferior para el menú de técnicos
class TecnicoMenuBottomNav extends StatelessWidget {
  const TecnicoMenuBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: TecnicoMenuTheme.navBarShadow(),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Inicio',
                isSelected: false,
                onTap: () => Navigator.pop(context),
              ),
              _buildNavItem(
                icon: Icons.engineering_rounded,
                label: 'Técnicos',
                isSelected: true,
                onTap: () {},
              ),
              _buildNavItem(
                icon: Icons.settings_rounded,
                label: 'Ajustes',
                isSelected: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected 
        ? TecnicoMenuTheme.selectedNavColor 
        : TecnicoMenuTheme.unselectedNavColor;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
