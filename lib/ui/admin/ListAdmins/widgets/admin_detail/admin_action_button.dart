import 'package:flutter/material.dart';
import 'admin_detail_constants.dart';

/// Botón de acción (Editar o Eliminar)
class AdminActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isOutlined;
  final VoidCallback onTap;
  
  const AdminActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isOutlined,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isTablet = sw > 600;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: AdminDetailTheme.buttonHeight(sh, isTablet),
          decoration: BoxDecoration(
            gradient: isOutlined ? null : AdminDetailTheme.editButtonGradient,
            color: isOutlined ? Colors.white : null,
            border: isOutlined 
                ? Border.all(color: AdminDetailTheme.deleteRed, width: 2) 
                : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              AdminDetailTheme.buttonShadow(
                isOutlined ? AdminDetailTheme.deleteRed : AdminDetailTheme.statusGreen,
                isOutlined: isOutlined,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isOutlined ? AdminDetailTheme.deleteRed : Colors.white,
                size: AdminDetailTheme.buttonIconSize(sw, isTablet),
              ),
              SizedBox(height: sh * 0.005),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AdminDetailTheme.buttonTextSize(sw, isTablet),
                    fontWeight: FontWeight.w600,
                    color: isOutlined ? AdminDetailTheme.deleteRed : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
