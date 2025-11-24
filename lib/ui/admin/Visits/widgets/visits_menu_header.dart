import 'package:flutter/material.dart';
import 'visits_menu_constants.dart';

/// Header con gradiente, decoraciones y título del menú de visitas
class VisitsMenuHeader extends StatelessWidget {
  const VisitsMenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;
    
    return Stack(
      children: [
        _buildGradientBackground(sh),
        _buildWaveClipPath(sh),
        _buildTitleAndBackButton(context, sw, sh),
      ],
    );
  }

  /// Gradiente de fondo con círculos decorativos
  Widget _buildGradientBackground(double sh) {
    return Container(
      height: VisitsMenuTheme.headerHeight(sh),
      decoration: const BoxDecoration(
        gradient: VisitsMenuTheme.primaryGradient,
      ),
      child: Stack(
        children: [
          // Círculo decorativo superior derecha
          Positioned(
            top: -50,
            right: -30,
            child: _buildDecorativeCircle(150, 0.1),
          ),
          // Círculo decorativo inferior izquierda
          Positioned(
            bottom: 20,
            left: -40,
            child: _buildDecorativeCircle(120, 0.08),
          ),
        ],
      ),
    );
  }

  /// Círculo decorativo semitransparente
  Widget _buildDecorativeCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }

  /// Wave clip path para efecto de onda
  Widget _buildWaveClipPath(double sh) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: VisitsMenuTheme.headerHeight(sh),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              VisitsMenuTheme.primaryGradientStart.withValues(alpha: 0.9),
              VisitsMenuTheme.primaryGradientEnd.withValues(alpha: 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  /// Botón de retroceso y título centrado
  Widget _buildTitleAndBackButton(BuildContext context, double sw, double sh) {
    return Positioned(
      top: VisitsMenuTheme.headerTopPosition(sh),
      left: sw * 0.025,
      right: sw * 0.025,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildBackButton(context, sw),
            _buildCenteredTitle(sw, sh),
          ],
        ),
      ),
    );
  }

  /// Botón de retroceso con fondo semitransparente
  Widget _buildBackButton(BuildContext context, double sw) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: VisitsMenuTheme.backButtonSize(sw),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  /// Título centrado con línea decorativa
  Widget _buildCenteredTitle(double sw, double sh) {
    return Center(
      child: Column(
        children: [
          Text(
            'Gestión de Visitas',
            style: TextStyle(
              color: Colors.white,
              fontSize: VisitsMenuTheme.titleFontSize(sw),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: sh * 0.005),
          Container(
            width: VisitsMenuTheme.decorativeLineWidth(sw),
            height: 3,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clipper personalizado para crear efecto de onda en el header
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);

    // Primera curva de Bézier
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Segunda curva de Bézier
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
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
