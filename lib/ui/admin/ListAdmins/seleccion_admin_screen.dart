import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/listAdmins/admins_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/service_ListAdmin.dart';
import 'list_admin_screen.dart';
import 'widgets/widgets_seleccion_admin/admin_menu_constants.dart';
import 'widgets/widgets_seleccion_admin/admin_menu_header.dart';
import 'widgets/widgets_seleccion_admin/admin_option_card.dart';
import 'widgets/widgets_seleccion_admin/admin_menu_bottom_nav.dart';

/// Pantalla principal del menú de administradores con diseño moderno y elegante
class AdminMenuScreen extends StatelessWidget {
  const AdminMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;
    
    return Scaffold(
      backgroundColor: AdminMenuTheme.backgroundColor,
      bottomNavigationBar: const AdminMenuBottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            const AdminMenuHeader(),
            Expanded(
              child: _buildContent(sw, sh),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el contenido principal con logo, texto de bienvenida y opciones
  Widget _buildContent(double sw, double sh) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AdminMenuTheme.horizontalPadding(sw),
        ),
        child: Column(
          children: [
            SizedBox(height: AdminMenuTheme.topSpacing(sh)),
            _buildLogo(sw),
            SizedBox(height: AdminMenuTheme.logoSpacing(sh)),
            _buildWelcomeText(sw),
            SizedBox(height: AdminMenuTheme.welcomeSpacing(sh)),
            _buildCreateAdminOption(),
            SizedBox(height: AdminMenuTheme.optionSpacing(sh)),
            _buildListAdminsOption(),
            SizedBox(height: AdminMenuTheme.bottomSpacing(sh)),
          ],
        ),
      ),
    );
  }

  /// Logo de la aplicación con Hero animation
  Widget _buildLogo(double sw) {
    return Hero(
      tag: 'logo',
      child: Image.asset(
        "assets/soluciones.png",
        height: AdminMenuTheme.logoSize(sw),
      ),
    );
  }

  /// Texto de bienvenida
  Widget _buildWelcomeText(double sw) {
    return Column(
      children: [
        Text(
          '¿Qué deseas hacer?',
          style: TextStyle(
            fontSize: AdminMenuTheme.welcomeTitleSize(sw),
            fontWeight: FontWeight.bold,
            color: AdminMenuTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecciona una opción para continuar',
          style: TextStyle(
            fontSize: AdminMenuTheme.welcomeSubtitleSize(sw),
            color: AdminMenuTheme.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Opción para crear administrador
  Widget _buildCreateAdminOption() {
    return AdminOptionCard(
      option: AdminMenuOption(
        title: "Crear Administrador",
        subtitle: "Registra un nuevo administrador",
        icon: Icons.person_add_rounded,
        gradient: AdminMenuTheme.createAdminGradient,
        onTap: () {
          // TODO: Implementar navegación a pantalla de crear administrador
        },
      ),
    );
  }

  /// Opción para ver lista de administradores
  Widget _buildListAdminsOption() {
    return Builder(
      builder: (context) {
        return AdminOptionCard(
          option: AdminMenuOption(
            title: "Lista de Administradores",
            subtitle: "Visualiza todos los administradores",
            icon: Icons.group_rounded,
            gradient: AdminMenuTheme.listAdminGradient,
            onTap: () => _navigateToListAdmins(context),
          ),
        );
      },
    );
  }

  /// Navega a la pantalla de lista de administradores
  void _navigateToListAdmins(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AdminsBloc(AdminRepository()),
          child: const AdminsScreen(),
        ),
      ),
    );
  }
}
