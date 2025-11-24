import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/request/request_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/request_repository.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request/request_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'visits_menu_constants.dart';

/// Barra de navegación inferior con diseño moderno
class VisitsMenuBottomNav extends StatelessWidget {
  const VisitsMenuBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: VisitsMenuTheme.navBarShadow(),
      ),
      child: BottomNavigationBar(
        onTap: (index) => _handleNavigation(context, index),
        selectedItemColor: VisitsMenuTheme.selectedNavColor,
        unselectedItemColor: VisitsMenuTheme.unselectedNavColor,
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: sw * 0.03,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: sw * 0.028,
        ),
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

  /// Maneja la navegación según el índice seleccionado
  void _handleNavigation(BuildContext context, int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => RequestBloc(RequestRepository()),
            child: const RequestScreen(),
          ),
        ),
      );
    }
  }
}
