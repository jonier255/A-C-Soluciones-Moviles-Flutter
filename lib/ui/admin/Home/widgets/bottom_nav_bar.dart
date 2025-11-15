import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/ui/admin/Profile/accountAdmin.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request/request_screen.dart';
import '../../../../bloc/request/request_bloc.dart';
import '../../../../repository/services_admin/request_repository.dart';
import 'admin_home_constants.dart';

/// Bottom navigation bar for admin home
class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => _handleNavigation(context, index),
      selectedItemColor: AdminHomeTheme.primaryBlue,
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Solicitudes',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cuenta'),
      ],
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;

      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sección de notificaciones en desarrollo'),
          ),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => RequestBloc(RequestRepository()),
              child: RequestScreen(),
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
  }
}
