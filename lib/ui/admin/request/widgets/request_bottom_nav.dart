import 'package:flutter/material.dart';
import '../../Home/admin_home.dart';
import 'request_screen_constants.dart';

/// Bottom navigation bar for request screen
class RequestBottomNavBar extends StatelessWidget {
  const RequestBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => _handleNavigation(context, index),
      selectedItemColor: RequestScreenTheme.primaryBlue,
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
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
      );
    }
  }
}
