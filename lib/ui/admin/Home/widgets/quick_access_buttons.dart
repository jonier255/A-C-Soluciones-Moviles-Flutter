import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/ui/admin/ListAdmins/seleccion_admin_screen.dart';
import 'package:flutter_a_c_soluciones/ui/admin/Visits/admin_menu_visits.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request/request_screen.dart';
import '../../../../bloc/request/request_bloc.dart';
import '../../../../repository/services_admin/request_repository.dart';
import 'admin_home_constants.dart';

/// Quick access buttons section (Servicios, Visitas, Admin, Solicitudes)
class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: const QuickButton(
                icon: Icons.build,
                label: "Servicios",
              ),
            ),
          ),
          const SizedBox(width: AdminHomeTheme.buttonSpacing),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VisitasMenuScreen(),
                  ),
                );
              },
              child: const QuickButton(
                icon: Icons.visibility,
                label: "Visitas",
              ),
            ),
          ),
          const SizedBox(width: AdminHomeTheme.buttonSpacing),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminMenuScreen(),
                  ),
                );
              },
              child: const QuickButton(
                icon: Icons.security,
                label: "Admin",
              ),
            ),
          ),
          const SizedBox(width: AdminHomeTheme.buttonSpacing),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => RequestBloc(RequestRepository()),
                      child: RequestScreen(),
                    ),
                  ),
                );
              },
              child: const QuickButton(
                icon: Icons.mail,
                label: "Solicitudes",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick access button with hover effect
class QuickButton extends StatefulWidget {
  final IconData icon;
  final String label;

  const QuickButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  State<QuickButton> createState() => _QuickButtonState();
}

class _QuickButtonState extends State<QuickButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 9),
        decoration: BoxDecoration(
          color: _isHovered ? AdminHomeTheme.accentBlue : AdminHomeTheme.lightGray,
          borderRadius: BorderRadius.circular(AdminHomeTheme.quickButtonRadius),
          boxShadow: [AdminHomeTheme.lightShadow()],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: _isHovered ? Colors.white : Colors.black,
              size: AdminHomeTheme.smallIconSize,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: _isHovered ? Colors.white : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
