import 'package:flutter/material.dart';
import '../../../../../model/administrador/admin_model.dart';
import 'admin_detail_constants.dart';

/// Sección de perfil con avatar y badge de rol
class AdminProfileSection extends StatelessWidget {
  final UpdateAdminRequest admin;
  
  const AdminProfileSection({
    super.key,
    required this.admin,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isTablet = sw > 600;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sw * 0.05,
        vertical: AdminDetailTheme.sectionSpacing(sh),
      ),
      child: Column(
        children: [
          _buildAvatar(sw, isTablet),
          SizedBox(height: sh * 0.025),
          _buildName(sw, isTablet),
          SizedBox(height: sh * 0.015),
          _buildRolBadge(sw, isTablet),
        ],
      ),
    );
  }

  /// Avatar circular con gradiente e iniciales
  Widget _buildAvatar(double sw, bool isTablet) {
    final avatarSize = AdminDetailTheme.avatarSize(sw, isTablet);
    
    return Hero(
      tag: 'admin_${admin.id}',
      child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AdminDetailTheme.avatarGradient,
          boxShadow: AdminDetailTheme.avatarShadow(),
          border: Border.all(color: Colors.white, width: 5),
        ),
        child: Center(
          child: Text(
            '${admin.nombre[0]}${admin.apellido[0]}'.toUpperCase(),
            style: TextStyle(
              fontSize: AdminDetailTheme.avatarTextSize(avatarSize),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// Nombre completo del administrador
  Widget _buildName(double sw, bool isTablet) {
    return Text(
      '${admin.nombre} ${admin.apellido}',
      style: TextStyle(
        fontSize: AdminDetailTheme.nameFontSize(sw, isTablet),
        fontWeight: FontWeight.bold,
        color: AdminDetailTheme.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Badge del rol con ícono verificado
  Widget _buildRolBadge(double sw, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sw * 0.05,
        vertical: sw * 0.012,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AdminDetailTheme.statusGreen.withOpacity(0.15),
            const Color(0xFF00B894).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AdminDetailTheme.statusGreen.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: AdminDetailTheme.rolIconSize(sw, isTablet),
            color: AdminDetailTheme.statusGreen,
          ),
          SizedBox(width: sw * 0.015),
          Text(
            admin.rol.toUpperCase(),
            style: TextStyle(
              fontSize: AdminDetailTheme.rolFontSize(sw, isTablet),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF00B894),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
