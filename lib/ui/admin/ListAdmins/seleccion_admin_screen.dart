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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? screenWidth * 0.15 : 24.0;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: const _BottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildLogoSection(),
                      const SizedBox(height: 30),
                      _buildWelcomeText(),
                      const SizedBox(height: 35),
                      _buildModernOptionCard(
                        context,
                        title: "Crear Administrador",
                        subtitle: "Registra un nuevo administrador",
                        icon: Icons.person_add_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D2A0), Color(0xFF00B894)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          // Acción para crear administrador
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildModernOptionCard(
                        context,
                        title: "Lista de Administradores",
                        subtitle: "Visualiza todos los administradores",
                        icon: Icons.group_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => AdminsBloc(AdminRepository()),
                                child: const AdminsScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleSize = screenWidth > 600 ? 30.0 : 26.0;
    final subtitleSize = screenWidth > 600 ? 16.0 : 14.0;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E91D8), Color(0xFF1E6BB8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E91D8).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Administradores',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gestión del sistema',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          _buildWaveDecoration(),
        ],
      ),
    );
  }

  Widget _buildWaveDecoration() {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 30,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E91D8), Color(0xFF1E6BB8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final logoSize = screenWidth > 600 ? 120.0 : 100.0;
        
        return Hero(
          tag: 'logo',
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset(
              "assets/soluciones.png",
              height: logoSize,
              width: logoSize,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeText() {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final titleSize = screenWidth > 600 ? 26.0 : 22.0;
        final subtitleSize = screenWidth > 600 ? 16.0 : 14.0;
        
        return Column(
          children: [
            Text(
              '¿Qué deseas hacer?',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona una opción para continuar',
              style: TextStyle(
                fontSize: subtitleSize,
                color: const Color(0xFF636E72),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModernOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final cardPadding = isTablet ? 32.0 : 24.0;
    final iconSize = isTablet ? 48.0 : 40.0;
    final titleSize = isTablet ? 20.0 : 18.0;
    final subtitleSize = isTablet ? 15.0 : 13.0;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: isTablet ? 700 : double.infinity,
          ),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: isTablet ? 24 : 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: isTablet ? 8 : 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class WaveClipper extends CustomClipper<Path> {
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

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => RequestBloc(RequestRepository()),
                  child: RequestScreen(),
                ),
              ),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2E91D8),
        unselectedItemColor: const Color(0xFF95A5A6),
        selectedFontSize: 12,
        unselectedFontSize: 11,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            label: 'Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Cuenta',
          ),
        ],
      ),
    );
  }
}
