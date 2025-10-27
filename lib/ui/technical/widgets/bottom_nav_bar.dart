import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)!.settings.name;

    int currentIndex = 0;
    if (currentRoute == '/technical_assigned_visits') {
      currentIndex = 1;
    } else if (currentRoute == '/technical_services') {
      currentIndex = 2;
    } else if (currentRoute == '/technical_reports') {
      currentIndex = 3;
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/technical_home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/technical_assigned_visits');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/technical_services');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/technical_reports');
            break;
        }
      },
      selectedItemColor: const Color.fromARGB(255, 46, 145, 216),
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.work_outline), label: 'Asignadas'),
        BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services), label: 'Servicios'),
        BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Reportes'),
      ],
    );
  }
}