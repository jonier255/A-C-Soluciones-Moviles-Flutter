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
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: topCurveHeight,
            color: RequestScreenTheme.primaryBlue,
          ),
        ),
        Positioned(
          top: titleTop,
          left: titleSidePadding,
          right: titleSidePadding,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: backButtonSize,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Center(
                child: Text(
                  'Lista de Solicitudes',
                  style: RequestScreenTheme.headerTitleStyle.copyWith(
                    fontSize: titleFontSize,
                  ),
                ),
              ),
            ],
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
