import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/request/request_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/request_repository.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request/request_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_menu_constants.dart';

/// Barra de navegación inferior del menú de administradores
class AdminMenuBottomNav extends StatelessWidget {
  const AdminMenuBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: AdminMenuTheme.navBarShadow(),
      ),
      child: BottomNavigationBar(
        onTap: (index) => _handleNavigation(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AdminMenuTheme.selectedNavColor,
        unselectedItemColor: AdminMenuTheme.unselectedNavColor,
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
