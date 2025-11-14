import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Profile/accountTechnical.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final currentRoute = ModalRoute.of(context)!.settings.name;

    int currentIndex = 0;
    if (currentRoute == '/technical_assigned_visits') {
      currentIndex = 1;
    } else if (currentRoute == '/technical_services') {
      currentIndex = 2;
    } else if (currentRoute == '/technical_profile') {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AccountTechnicalScreen(),
              ),
            );
            break;
        }
      },
      selectedItemColor: const Color.fromARGB(255, 46, 145, 216),
      unselectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(fontSize: screenWidth * 0.03),
      unselectedLabelStyle: TextStyle(fontSize: screenWidth * 0.028),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home, size: screenWidth * 0.06), label: 'Inicio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.work_outline, size: screenWidth * 0.06), label: 'Asignadas'),
        BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services, size: screenWidth * 0.06), label: 'Servicios'),
        BottomNavigationBarItem(icon: Icon(Icons.person, size: screenWidth * 0.06), label: 'Cuenta'),
      ],
    );
  }
}