import 'package:flutter/material.dart';
import '../../../../model/administrador/admin_model.dart';
import '../admin_detail_screen.dart';

/// Tarjeta que muestra la información de un administrador
class AdminCard extends StatelessWidget {
  final UpdateAdminRequest admin;

  const AdminCard({
    super.key,
    required this.admin,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final cardMargin = isTablet ? 20.0 : 16.0;
    final cardPadding = isTablet ? 24.0 : 20.0;
    final avatarSize = isTablet ? 70.0 : 60.0;
    final nameSize = isTablet ? 19.0 : 17.0;
    final infoSize = isTablet ? 14.0 : 13.0;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: cardMargin, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFFAFBFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navegar a la pantalla de detalle del administrador
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminDetailScreen(admin: admin),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Row(
              children: [
                _buildAvatar(avatarSize),
                SizedBox(width: isTablet ? 20 : 16),
                Expanded(child: _buildAdminInfo(nameSize, infoSize)),
                _buildArrowIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(double size) {
    final initials = (admin.nombre.isNotEmpty && admin.apellido.isNotEmpty)
        ? '${admin.nombre[0]}${admin.apellido[0]}'.toUpperCase()
        : 'AD';
    final fontSize = size * 0.33;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 24, 48, 189), Color(0xFF00B894)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 22, 25, 192).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAdminInfo(double nameSize, double infoSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${admin.nombre} ${admin.apellido}",
          style: TextStyle(
            fontSize: nameSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 6),
        _buildInfoRow(Icons.badge_rounded, admin.numeroCedula, infoSize),
        const SizedBox(height: 4),
        _buildInfoRow(Icons.email_rounded, admin.correoElectronico, infoSize),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, double fontSize) {
    return Row(
      children: [
        Icon(
          icon,
          size: fontSize + 3,
          color: const Color(0xFF636E72),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: const Color(0xFF636E72),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildArrowIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Color.fromARGB(255, 27, 44, 201),
      ),
    );
  }
}
