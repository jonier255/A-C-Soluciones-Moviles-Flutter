import 'package:flutter/material.dart';
import 'service_menu_constants.dart';

class ServiceMenuHeader extends StatelessWidget {
  const ServiceMenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: ServiceMenuTheme.primaryGradient,
        boxShadow: ServiceMenuTheme.headerShadow(),
      ),
      child: Column(
        children: [
          _buildHeaderContent(context),
          _buildWaveDecoration(),
        ],
      ),
    );
  }

  Widget _buildHeaderContent(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Row(
        children: [
          _buildBackButton(context, sw),
          Expanded(child: _buildTitleSection(sw)),
          SizedBox(width: ServiceMenuTheme.backButtonSize(sw)),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, double sw) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: ServiceMenuTheme.backButtonSize(sw) * 0.5,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildTitleSection(double sw) {
    return Column(
      children: [
        Text(
          'Servicios',
          style: TextStyle(
            color: Colors.white,
            fontSize: ServiceMenuTheme.headerTitleSize(sw),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Gestión de servicios',
          style: TextStyle(
            color: Colors.white.withAlpha(230),
            fontSize: ServiceMenuTheme.headerSubtitleSize(sw),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildWaveDecoration() {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        height: 30,
        decoration: const BoxDecoration(
          gradient: ServiceMenuTheme.primaryGradient,
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    var firstControlPoint = Offset(size.width * 0.25, size.height - 15);
    var firstEndPoint = Offset(size.width * 0.5, size.height);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

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
