import 'package:flutter/material.dart';
import 'admin_home_constants.dart';

/// Wave-shaped header with logo and gradient
class WaveHeader extends StatelessWidget {
  const WaveHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: AdminHomeTheme.waveHeaderHeight(sh),
        decoration: const BoxDecoration(
          gradient: AdminHomeTheme.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF667eea),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Círculos decorativos
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            // Logo centrado
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Hero(
                  tag: 'admin_logo',
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      "assets/soluciones.png",
                      height: AdminHomeTheme.logoHeight(sh),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom clipper for wave shape
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

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
