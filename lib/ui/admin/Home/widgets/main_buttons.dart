import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/tecnicos/tecnicos_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/tecnicos_repository.dart';
import 'package:flutter_a_c_soluciones/ui/admin/GestionTecnicos/create_technical_screen.dart';
import 'package:flutter_a_c_soluciones/ui/admin/GestionTecnicos/seleccion_tecnico_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_home_constants.dart';

/// Sección con botones principales de acción (Técnico, Cliente)
class MainButtonsSection extends StatelessWidget {
  const MainButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AdminHomeTheme.horizontalPadding(sw)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: MainButton(
              icon: Icons.engineering_rounded,
              label: "Gestión de técnicos",
              gradient: AdminHomeTheme.technicoGradient,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TecnicoMenuScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: MainButton(
              icon: Icons.person_rounded,
              label: "Gestión de clientes",
              gradient: AdminHomeTheme.clienteGradient,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => TecnicosBloc(tecnicosRepository: TecnicosRepository()),
                      child: const CreateTechnicalScreen(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Botón principal con gradiente y efecto de elevación
class MainButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;
  

  const MainButton({
    super.key,
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AdminHomeTheme.mainButtonRadius),
        child: Container(
          height: AdminHomeTheme.mainButtonHeight(sh),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AdminHomeTheme.mainButtonRadius),
            boxShadow: AdminHomeTheme.buttonShadow(gradient.colors.first),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: AdminHomeTheme.mainButtonIconSize(sw) * 0.7,
                  color: Colors.white,
                ),
                SizedBox(height: sh * 0.005),
                Text(
                  label,
                  style: AdminHomeTheme.buttonLabelStyle(sw),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
