import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/service/service_bloc.dart';
import '../Home/widgets/bottom_nav_bar.dart';
import 'create_service_screen.dart';
import 'service_list_screen.dart';
import 'widgets/service_menu_constants.dart';
import 'widgets/service_menu_header.dart';
import 'widgets/service_option_card.dart';



class ServiceMenuScreen extends StatelessWidget {
  const ServiceMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;   
    final sh = MediaQuery.of(context).size.height;  
    
    return Scaffold(
      backgroundColor: ServiceMenuTheme.backgroundColor,
      bottomNavigationBar: const AdminBottomNavBar(),
      body: SafeArea(  
        child: Column(  
          children: [
            const ServiceMenuHeader(),
            
            Expanded(  
              child: SingleChildScrollView(  
                physics: const BouncingScrollPhysics(),  
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ServiceMenuTheme.screenHorizontalPadding(sw),  // Márgenes laterales
                  ),
                  child: Column(  
                    children: [
                      SizedBox(height: sh * 0.025),  
                      
                      _buildLogo(sw),
                      
                      SizedBox(height: ServiceMenuTheme.logoSpacing(sh)),  
                      
                      _buildWelcomeText(sw),
                      
                      SizedBox(height: ServiceMenuTheme.welcomeSpacing(sh)),  
                      _buildOptionCard(
                        context: context,
                        option: _createServiceOption(context),
                      ),
                      
                      SizedBox(height: sh * 0.025),  
                      
                      _buildOptionCard(
                        context: context,
                        option: _listServicesOption(context),
                      ),
                      
                      SizedBox(height: sh * 0.03), 
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

  
  ServiceMenuOption _createServiceOption(BuildContext context) {
    return ServiceMenuOption(
      title: 'Crear Nuevo Servicio',
      subtitle: 'Registra un nuevo servicio en el sistema',
      icon: Icons.add_business_rounded,  
      gradient: ServiceMenuTheme.createServiceGradient,  
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateServiceScreen(),
          ),
        );
      },
    );
  }

  ServiceMenuOption _listServicesOption(BuildContext context) {
    return ServiceMenuOption(
      title: 'Lista de Servicios',
      subtitle: 'Consulta todos los servicios registrados',
      icon: Icons.list_alt_rounded,  
      gradient: ServiceMenuTheme.listServiceGradient,  
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ServiceBloc(),
              child: const ServiceListScreen(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required ServiceMenuOption option,
  }) {
    return Hero(
      tag: 'service_option_${option.title}',  
      child: ServiceOptionCard(option: option),  
    );
  }

  Widget _buildLogo(double sw) {
    return Hero(
      tag: 'logo',  
      child: Image.asset(
        "assets/soluciones.png",  
        height: ServiceMenuTheme.logoSize(sw),  
      ),
    );
  }

  
  Widget _buildWelcomeText(double sw) {
    return Column(
      children: [
        Text(
          '¿Qué deseas hacer?',
          style: TextStyle(
            fontSize: ServiceMenuTheme.welcomeTitleSize(sw),
            fontWeight: FontWeight.bold,
            color: ServiceMenuTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),  
        Text(
          'Selecciona una opción para continuar',
          style: TextStyle(
            fontSize: ServiceMenuTheme.welcomeSubtitleSize(sw),
            color: ServiceMenuTheme.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
