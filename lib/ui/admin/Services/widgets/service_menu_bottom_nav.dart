import 'package:flutter/material.dart';
import 'service_menu_constants.dart';

class ServiceMenuBottomNav extends StatelessWidget {
  final int currentIndex;
  
  const ServiceMenuBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [ServiceMenuTheme.bottomNavShadow],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ServiceMenuTheme.bottomNavHorizontalPadding(sw),
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.dashboard_rounded,
                label: 'Panel',
                index: 0,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'Perfil',
                index: 1,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.settings_rounded,
                label: 'Config',
                index: 2,
                context: context,
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
    required int index,
    required BuildContext context,
  }) {
    final sw = MediaQuery.of(context).size.width;
    final isActive = currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive 
                    ? ServiceMenuTheme.primaryPurple 
                    : ServiceMenuTheme.textSecondary,
                size: ServiceMenuTheme.bottomNavIconSize(sw),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: ServiceMenuTheme.bottomNavLabelSize(sw),
                  color: isActive 
                      ? ServiceMenuTheme.primaryPurple
                      : ServiceMenuTheme.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}