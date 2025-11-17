import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/editProfileAdmin/edit_profile_admin_bloc.dart';
import '../../../../model/administrador/admin_model.dart';
import '../../../../repository/secure_storage_service.dart';
import 'profile_constants.dart';
import 'profile_text_field.dart';

/// Formulario de edición de información personal del administrador
class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final TextEditingController correoController;
  final TextEditingController cedulaController;

  const ProfileForm({
    super.key,
    required this.formKey,
    required this.nombreController,
    required this.apellidoController,
    required this.correoController,
    required this.cedulaController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth > ProfileTheme.formMaxWidth 
            ? ProfileTheme.formMaxWidth 
            : screenWidth,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ProfileTheme.formPadding,
            vertical: ProfileTheme.formVerticalPadding,
          ),
          decoration: BoxDecoration(
            color: ProfileTheme.backgroundColor,
            borderRadius: BorderRadius.circular(ProfileTheme.formBorderRadius),
            boxShadow: ProfileTheme.cardShadow(),
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ProfileTextField(
                  controller: nombreController,
                  label: "Nombre",
                  icon: Icons.person,
                  accent: ProfileTheme.primaryBlue,
                ),
                const SizedBox(height: ProfileTheme.fieldSpacing),
                ProfileTextField(
                  controller: apellidoController,
                  label: "Apellido",
                  icon: Icons.person_outline,
                  accent: ProfileTheme.primaryBlue,
                ),
                const SizedBox(height: ProfileTheme.fieldSpacing),
                ProfileTextField(
                  controller: correoController,
                  label: "Correo electrónico",
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email,
                  accent: ProfileTheme.primaryBlue,
                ),
                const SizedBox(height: ProfileTheme.fieldSpacing),
                ProfileTextField(
                  controller: cedulaController,
                  label: "Número de cédula",
                  keyboardType: TextInputType.number,
                  icon: Icons.badge,
                  accent: ProfileTheme.primaryBlue,
                ),
                const SizedBox(height: 26),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ProfileTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            onPressed: () => _handleSave(context),
            child: const Text(
              "Guardar cambios",
              style: ProfileTheme.buttonTextStyle,
            ),
          ),
        ),
        const SizedBox(width: ProfileTheme.buttonSpacing),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: ProfileTheme.cancelButtonTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final storage = SecureStorageService();
      final adminIdStr = await storage.getAdminId();
      
      if (adminIdStr == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID de administrador no encontrado. Vuelva a iniciar sesión.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final parsedId = int.tryParse(adminIdStr) ?? 0;

      final updatedAdmin = UpdateAdminRequest(
        id: parsedId,
        nombre: nombreController.text,
        apellido: apellidoController.text,
        numeroCedula: cedulaController.text,
        correoElectronico: correoController.text,
        rol: 'administrador',
      );

      context.read<EditProfileAdminBloc>().add(
        UpdateAdminProfile(adminData: updatedAdmin),
      );
    }
  }
}
