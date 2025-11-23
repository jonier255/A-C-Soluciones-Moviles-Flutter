import 'package:flutter/material.dart';
import 'admin_menu_constants.dart';

/// Header del menú de administradores con gradiente y decoración wave
class AdminMenuHeader extends StatelessWidget {
  const AdminMenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AdminMenuTheme.primaryGradient,
        boxShadow: AdminMenuTheme.headerShadow(),
      ),
      child: Column(
        children: [
          _buildHeaderContent(context),
          _buildWaveDecoration(),
        ],
      ),
    );
  }

  /// Contenido principal del header con título y botón de retroceso
  Widget _buildHeaderContent(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Row(
        children: [
          _buildBackButton(context, sw),
          Expanded(child: _buildTitleSection(sw)),
          SizedBox(width: AdminMenuTheme.backButtonSize(sw)),
        ],
      ),
    );
  }

  /// Botón de retroceso con fondo translúcido
  Widget _buildBackButton(BuildContext context, double sw) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: AdminMenuTheme.backButtonSize(sw) * 0.5,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  /// Sección de título y subtítulo centrados
  Widget _buildTitleSection(double sw) {
    return Column(
      children: [
        Text(
          'Administradores',
          style: TextStyle(
            color: Colors.white,
            fontSize: AdminMenuTheme.headerTitleSize(sw),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Gestión del sistema',
          style: TextStyle(
            color: Colors.white70,
            fontSize: AdminMenuTheme.headerSubtitleSize(sw),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Decoración wave en la parte inferior del header
  Widget _buildWaveDecoration() {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        height: 30,
        decoration: const BoxDecoration(
          gradient: AdminMenuTheme.primaryGradient,
        ),
      ),
    );
  }
}

/// Custom clipper para crear el efecto de onda
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    // Primera curva
    var firstControlPoint = Offset(size.width * 0.25, size.height - 15);
    var firstEndPoint = Offset(size.width * 0.5, size.height);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Segunda curva
    var secondControlPoint = Offset(size.width * 0.75, size.height + 15);
    var secondEndPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
