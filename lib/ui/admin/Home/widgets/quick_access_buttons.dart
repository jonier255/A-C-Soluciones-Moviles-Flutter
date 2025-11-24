import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/admin/ListAdmins/seleccion_admin_screen.dart';
import 'package:flutter_a_c_soluciones/ui/admin/Services/service_menu_screen.dart';
import 'package:flutter_a_c_soluciones/ui/admin/Visits/admin_menu_visits.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request/request_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/request/request_bloc.dart';
import '../../../../repository/services_admin/request_repository.dart';
import 'admin_home_constants.dart';

/// Sección de botones de acceso rápido (Servicios, Visitas, Admin, Solicitudes)
class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AdminHomeTheme.horizontalPadding(sw)),
      child: Row(
        children: [
          Expanded(
            child: QuickButton(
              icon: Icons.build_rounded,
              label: "Servicios",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServiceMenuScreen(),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: AdminHomeTheme.buttonSpacing(sw)),
          Expanded(
            child: QuickButton(
              icon: Icons.visibility_rounded,
              label: "Visitas",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VisitasMenuScreen(),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: AdminHomeTheme.buttonSpacing(sw)),
          Expanded(
            child: QuickButton(
              icon: Icons.admin_panel_settings_rounded,
              label: "Admin",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminMenuScreen(),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: AdminHomeTheme.buttonSpacing(sw)),
          Expanded(
            child: QuickButton(
              icon: Icons.assignment_rounded,
              label: "Solicitudes",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => RequestBloc(RequestRepository()),
                      child: const RequestScreen(),
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

/// Botón de acceso rápido con diseño moderno
class QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickButton({
    super.key,
    required this.icon,
    required this.label,
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
        borderRadius: BorderRadius.circular(AdminHomeTheme.quickButtonRadius),
        child: Container(
          height: AdminHomeTheme.quickButtonHeight(sh),
          decoration: BoxDecoration(
            color: AdminHomeTheme.cardBackground,
            borderRadius: BorderRadius.circular(AdminHomeTheme.quickButtonRadius),
            boxShadow: AdminHomeTheme.quickButtonShadow(),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(sw * 0.015),
                  decoration: BoxDecoration(
                    gradient: AdminHomeTheme.accentGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: AdminHomeTheme.quickButtonIconSize(sw),
                  ),
                ),
                SizedBox(height: sh * 0.004),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: AdminHomeTheme.quickButtonTextSize(sw),
                      fontWeight: FontWeight.w600,
                      color: AdminHomeTheme.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
