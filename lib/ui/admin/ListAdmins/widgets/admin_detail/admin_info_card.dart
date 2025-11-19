import 'package:flutter/material.dart';
import 'admin_detail_constants.dart';

/// Tarjeta de información con ícono, título y valor
class AdminInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final LinearGradient gradient;
  
  const AdminInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final isTablet = sw > 600;
    final padding = AdminDetailTheme.cardPadding(sw, isTablet);
    final iconSize = AdminDetailTheme.cardIconSize(sw, isTablet);
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AdminDetailTheme.cardShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconSize * 1.3,
            height: iconSize * 1.3,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: iconSize * 0.7,
            ),
          ),
          SizedBox(height: padding * 0.5),
          Text(
            title,
            style: TextStyle(
              fontSize: AdminDetailTheme.cardTitleSize(sw, isTablet),
              color: AdminDetailTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: AdminDetailTheme.cardValueSize(sw, isTablet),
              color: AdminDetailTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
