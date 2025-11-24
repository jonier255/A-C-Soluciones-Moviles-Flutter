import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/visits_repository.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/service_api_visits.dart';
import 'package:flutter_a_c_soluciones/bloc/administrador/visits/assign_visits/assign_visits_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/administrador/visits/visits_bloc.dart';
import 'assign_visits_screen.dart';
import 'visits_screen.dart';
import 'widgets/visits_menu_constants.dart';
import 'widgets/visits_menu_header.dart';
import 'widgets/visits_option_card.dart';
import 'widgets/visits_menu_bottom_nav.dart';

/// Pantalla principal del menú de visitas con diseño moderno y elegante
class VisitasMenuScreen extends StatelessWidget {
  const VisitasMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;
    
    return Scaffold(
      backgroundColor: VisitsMenuTheme.backgroundColor,
      bottomNavigationBar: const VisitsMenuBottomNav(),
      body: Column(
        children: [
          const VisitsMenuHeader(),
          Expanded(
            child: _buildContent(context, sw, sh),
          ),
        ],
      ),
    );
  }

  /// Construye el contenido principal con logo y tarjetas de opciones
  Widget _buildContent(BuildContext context, double sw, double sh) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: VisitsMenuTheme.contentPaddingH(sw),
      ),
      child: Column(
        children: [
          SizedBox(height: VisitsMenuTheme.topSpacing(sh)),
          _buildLogo(sh),
          SizedBox(height: VisitsMenuTheme.logoSpacing(sh)),
          _buildOptionsContainer(context, sw, sh),
          SizedBox(height: VisitsMenuTheme.bottomSpacing(sh)),
        ],
      ),
    );
  }

  /// Logo de la aplicación con Hero animation
  Widget _buildLogo(double sh) {
    return Hero(
      tag: 'app_logo',
      child: Image.asset(
        "assets/soluciones.png",
        height: VisitsMenuTheme.logoHeight(sh),
      ),
    );
  }

  /// Contenedor de opciones con sombra elegante
  Widget _buildOptionsContainer(BuildContext context, double sw, double sh) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: VisitsMenuTheme.containerShadow(),
      ),
      padding: EdgeInsets.symmetric(
        vertical: VisitsMenuTheme.cardPaddingV(sh),
        horizontal: VisitsMenuTheme.cardPaddingH(sw),
      ),
      child: Column(
        children: [
          _buildAssignVisitsOption(context),
          SizedBox(height: VisitsMenuTheme.optionSpacing(sh)),
          _buildListVisitsOption(context),
        ],
      ),
    );
  }

  /// Opción para asignar visitas
  Widget _buildAssignVisitsOption(BuildContext context) {
    return VisitsOptionCard(
      option: VisitsMenuOptions.assignVisits,
      onTap: () => _navigateToAssignVisits(context),
    );
  }

  /// Opción para ver lista de visitas
  Widget _buildListVisitsOption(BuildContext context) {
    return VisitsOptionCard(
      option: VisitsMenuOptions.listVisits,
      onTap: () => _navigateToListVisits(context),
    );
  }

  /// Navega a la pantalla de asignar visitas
  void _navigateToAssignVisits(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AssignVisitsBloc(
            visitsRepository: VisitsRepository(),
          ),
          child: const AssignVisitsScreen(),
        ),
      ),
    );
  }

  /// Navega a la pantalla de lista de visitas
  void _navigateToListVisits(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => VisitsBloc(ListVisitsRepository()),
          child: VisitsScreen(),
        ),
      ),
    );
  }
}
