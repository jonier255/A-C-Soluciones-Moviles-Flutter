import 'package:flutter/material.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Image.asset(
                    "assets/soluciones.png",
                    height: 200,
                  ),
                  const SizedBox(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 39, 128, 192)
                                .withValues(alpha: 0.9),
                            spreadRadius: 2,
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Recuperar Contraseña",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 27, 108, 175)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Ingrese su correo electronico para poder enviarle el codigo de recuperacion.",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 112, 184, 235),
                                    width: 2.0),
                              ),
                              labelText: "Correo Electrónico",
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/verify');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                backgroundColor:
                                    const Color.fromARGB(255, 39, 128, 192),
                                elevation: 10,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Enviar Codigo",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // La curva en la parte superior
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 180,
              color: const Color.fromARGB(255, 39, 128, 192),
            ),
          ),


          // Botón de retroceso
          Positioned(
            top: 20,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// curva azul
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

