import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/listAdmins/admins_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/request/request_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/request_repository.dart';
import 'package:flutter_a_c_soluciones/ui/admin/ListAdmins/list_admin_screen.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request/request_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/services_admin/service_ListAdmin.dart';

class AdminMenuScreen extends StatelessWidget {
  const AdminMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _BottomNavBar(),
            body: Column(
              children: [
                Stack(
                  children: [
                    // Curva azul superior
                    ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        height: 180,
                        color: Color.fromARGB(255, 46, 145, 216),
                      ),
                    ),
                    // Botón de retroceso y título
                    Positioned(
                      top: 40,
                      left: 10,
                      right: 10,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white, size: 30),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Center(
                            child: const Text(
                              'Seccion de Administradores',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ListView(
                      padding: EdgeInsets.zero, 
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/soluciones.png",
                                height: 130,
                              ),
                              const SizedBox(height: 20),
                              // Se ha envuelto las tarjetas de opciones en un Card con sombra azul.
                              Card(
                                elevation: 10.0,
                                shadowColor: const Color.fromARGB(255, 7, 110, 194),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 20),
                                    _buildOptionCard(
                                      context,
                                      title: "Crear Administrador",
                                      icon: Icons.person_add,
                                      color: const Color.fromARGB(255, 2, 247, 153),
                                      onTap: () {
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    _buildOptionCard(
                                      context,
                                      title: "Lista de Administradores",
                                      icon: Icons.list_alt,
                                      color: const Color.fromARGB(255, 175, 61, 166),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  AdminsBloc(AdminRepository()),
                                              child: AdminsScreen(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                  ],
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
            ),    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 60, color: Colors.black),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

//la seccion del menu de abajo
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => RequestBloc(RequestRepository()),
              child: RequestScreen(),
            ),
          ),
        );
      },
      selectedItemColor: const Color.fromARGB(255, 46, 145, 216),
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: 'Notificaciones'),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment), label: 'Solicitudes'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cuenta'),
      ],
    );
  }
}
