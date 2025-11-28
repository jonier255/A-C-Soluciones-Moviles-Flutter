import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/administrador/editProfileAdmin/edit_profile_admin_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/administrador/request/request_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/request_repository.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/service_admin_update_profile.dart';
import 'package:flutter_a_c_soluciones/ui/admin/Home/admin_home.dart';
import 'package:flutter_a_c_soluciones/ui/admin/Profile/update_profile_admin.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request/request_screen.dart';
import 'package:flutter_a_c_soluciones/ui/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CuentaScreen extends StatelessWidget {
  const CuentaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const _BottomNavBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 170,
                color: const Color.fromARGB(255, 46, 145, 216),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 16.0),
                  child: Center(
                    child: ColorFiltered(
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: Image.asset(
                        "assets/logo.png",
                        height: 120,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 160),
                    const Icon(Icons.account_circle,
                        size: 100, color: Colors.blue),
                    const SizedBox(height: 10),
                    const Text(
                      "Cuenta",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildOptionButton(
                            icon: Icons.person_outline,
                            label: "Ver perfil",
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Funcionalidad de 'Ver perfil' aún no implementada"),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          _buildOptionButton(
                            icon: Icons.edit_outlined,
                            label: "Editar perfil",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => EditProfileAdminBloc(
                                      adminUpdateProfileRepository:
                                          AdminUpdateProfileRepository(),
                                    ),
                                    child: const EditarInformacionScreen(),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5,
                            ),
                                                        onPressed: () async {
                              final secureStorage = SecureStorageService();
                              await secureStorage.clearAll();
                              if (context.mounted) {
                                await Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            child: const Text(
                              "Cerrar Sesión",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black87),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Colors.black12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

/// curva de arriba
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
        switch (index) {
          case 0:
            Navigator.push
            (context, 
              MaterialPageRoute(
                builder: (context) => const AdminHomeScreen(),
              ),
            );
            break;

          case 1:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Sección de notificaciones en desarrollo')),
            );
            break;

          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => RequestBloc(RequestRepository()),
                  child: const RequestScreen(),
                ),
              ),
            );
            break;

          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CuentaScreen(),
              ),
            );
            break;
        }
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
