import 'package:flutter/material.dart';
import '../../../model/administrador/admin_model.dart';
import 'widgets/admin_detail/admin_detail_constants.dart';
import 'widgets/admin_detail/admin_detail_header.dart';
import 'widgets/admin_detail/admin_profile_section.dart';
import 'widgets/admin_detail/admin_info_card.dart';
import 'widgets/admin_detail/admin_action_button.dart';
import 'widgets/admin_detail/delete_admin_dialog.dart';

/// Pantalla de detalle de administrador con diseño moderno y limpio
class AdminDetailScreen extends StatelessWidget {
  final UpdateAdminRequest admin;
  
  const AdminDetailScreen({
    super.key,
    required this.admin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminDetailTheme.backgroundColor,
      body: Column(
        children: [
          const AdminDetailHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AdminProfileSection(admin: admin),
                  _buildInfoGrid(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Grid de información y botones de acción
  Widget _buildInfoGrid(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final spacing = AdminDetailTheme.cardSpacing(sh);
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AdminDetailTheme.horizontalPadding(sw),
      ),
      child: Column(
        children: [
          // Primera fila: Cédula y Correo
          Row(
            children: [
              Expanded(
                child: AdminInfoCard(
                  icon: Icons.badge_outlined,
                  title: 'Cédula',
                  value: admin.numeroCedula,
                  gradient: AdminDetailTheme.cedulaGradient,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: AdminInfoCard(
                  icon: Icons.email_outlined,
                  title: 'Correo',
                  value: admin.correoElectronico,
                  gradient: AdminDetailTheme.correoGradient,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          // Segunda fila: Nombre y Apellido
          Row(
            children: [
              Expanded(
                child: AdminInfoCard(
                  icon: Icons.person_outline,
                  title: 'Nombre',
                  value: admin.nombre,
                  gradient: AdminDetailTheme.nombreGradient,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: AdminInfoCard(
                  icon: Icons.person_outline_rounded,
                  title: 'Apellido',
                  value: admin.apellido,
                  gradient: AdminDetailTheme.apellidoGradient,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          // Tercera fila: Botones de acción
          Row(
            children: [
              Expanded(
                child: AdminActionButton(
                  label: 'Editar',
                  icon: Icons.edit_rounded,
                  isOutlined: false,
                  onTap: () {
                    // TODO: Implementar edición
                  },
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: AdminActionButton(
                  label: 'Eliminar',
                  icon: Icons.delete_rounded,
                  isOutlined: true,
                  onTap: () => DeleteAdminDialog.show(context, admin),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
