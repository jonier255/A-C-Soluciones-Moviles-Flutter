import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/tecnicos/tecnicos_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/tecnicos_repository.dart';
import 'package:flutter_a_c_soluciones/ui/admin/Home/widgets/bottom_nav_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_technical_screen.dart';
import 'list_tecnicos_screen.dart';
import 'widgets/widgets_seleccion_tecnico/tecnico_menu_constants.dart';
import 'widgets/widgets_seleccion_tecnico/tecnico_menu_header.dart';
import 'widgets/widgets_seleccion_tecnico/tecnico_option_card.dart';

/// Pantalla principal del menú de técnicos con diseño moderno y elegante
class TecnicoMenuScreen extends StatelessWidget {
  const TecnicoMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;
    
    return Scaffold(
      backgroundColor: TecnicoMenuTheme.backgroundColor,
      bottomNavigationBar: const AdminBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            const TecnicoMenuHeader(),
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
          horizontal: TecnicoMenuTheme.horizontalPadding(sw),
        ),
        child: Column(
          children: [
            SizedBox(height: TecnicoMenuTheme.topSpacing(sh)),
            _buildLogo(sw),
            SizedBox(height: TecnicoMenuTheme.logoSpacing(sh)),
            _buildWelcomeText(sw),
            SizedBox(height: TecnicoMenuTheme.welcomeSpacing(sh)),
            _buildCreateTecnicoOption(),
            SizedBox(height: TecnicoMenuTheme.optionSpacing(sh)),
            _buildListTecnicosOption(),
            SizedBox(height: TecnicoMenuTheme.bottomSpacing(sh)),
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
        height: TecnicoMenuTheme.logoSize(sw),
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
            fontSize: TecnicoMenuTheme.welcomeTitleSize(sw),
            fontWeight: FontWeight.bold,
            color: TecnicoMenuTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gestiona el equipo de técnicos',
          style: TextStyle(
            fontSize: TecnicoMenuTheme.welcomeSubtitleSize(sw),
            color: TecnicoMenuTheme.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Opción para crear técnico
  Widget _buildCreateTecnicoOption() {
    return Builder(
      builder: (context) {
        return TecnicoOptionCard(
          option: TecnicoMenuOption(
            title: "Crear Técnico",
            subtitle: "Registra un nuevo técnico en el sistema",
            icon: Icons.person_add_alt_rounded,
            gradient: TecnicoMenuTheme.createTecnicoGradient,
            onTap: () => _navigateToCreateTecnico(context),
          ),
        );
      },
    );
  }

  /// Opción para ver lista de técnicos
  Widget _buildListTecnicosOption() {
    return Builder(
      builder: (context) {
        return TecnicoOptionCard(
          option: TecnicoMenuOption(
            title: "Lista de Técnicos",
            subtitle: "Visualiza y administra todos los técnicos",
            icon: Icons.engineering_rounded,
            gradient: TecnicoMenuTheme.listTecnicoGradient,
            onTap: () => _navigateToListTecnicos(context),
          ),
        );
      },
    );
  }

  /// Navega a la pantalla de crear técnico
  void _navigateToCreateTecnico(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTechnicalScreen(),
      ),
    );
  }

  /// Navega a la pantalla de lista de técnicos
  void _navigateToListTecnicos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => TecnicosBloc(tecnicosRepository: TecnicosRepository()),
          child: const ListTecnicosScreen(),
        ),
      ),
    );
  }
}
