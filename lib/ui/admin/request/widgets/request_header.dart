import 'package:flutter/material.dart';
import 'request_screen_constants.dart';

/// Header with wave background and title
class RequestScreenHeader extends StatelessWidget {
  const RequestScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topCurveHeight = RequestScreenTheme.topCurveHeight(size.height);
    final titleTop = RequestScreenTheme.titleTop(size.height);
    final titleSidePadding = RequestScreenTheme.titleSidePadding(size.width);
    final titleFontSize = RequestScreenTheme.titleFontSize(size.width);
    final backButtonSize = RequestScreenTheme.backButtonSize(size.width);

    return Stack(
      children: [
        // Gradient background with decorative circles
        Container(
          height: topCurveHeight,
          decoration: const BoxDecoration(
            gradient: RequestScreenTheme.primaryGradient,
          ),
          child: Stack(
            children: [
              Positioned(
                top: -50,
                right: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: -40,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Wave clip path
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: topCurveHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  RequestScreenTheme.primaryGradientStart.withOpacity(0.9),
                  RequestScreenTheme.primaryGradientEnd.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        // Title and back button
        Positioned(
          top: titleTop,
          left: titleSidePadding,
          right: titleSidePadding,
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: backButtonSize,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Lista de Solicitudes',
                        style: RequestScreenTheme.headerTitleStyle.copyWith(
                          fontSize: titleFontSize,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
