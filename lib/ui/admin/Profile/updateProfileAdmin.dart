import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/administrador/editProfileAdmin/edit_profile_admin_bloc.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_form.dart';
import 'widgets/profile_constants.dart';

/// Pantalla de edición de información personal del administrador
class EditarInformacionScreen extends StatefulWidget {
  const EditarInformacionScreen({super.key});

  @override
  State<EditarInformacionScreen> createState() => _EditarInformacionScreenState();
}

class _EditarInformacionScreenState extends State<EditarInformacionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditProfileAdminBloc>().add(LoadAdminProfile());
    });
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    correoController.dispose();
    cedulaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileAdminBloc, EditProfileAdminState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ProfileTheme.backgroundColor,
          appBar: const ProfileHeader(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                const ProfileBanner(),
                const SizedBox(height: ProfileTheme.spacingSmall),
                const SizedBox(height: 10),
                _buildAvatar(state),
                const SizedBox(height: 20),
                const Text(
                  "Editar información personal",
                  style: ProfileTheme.sectionTitleStyle,
                ),
                const SizedBox(height: ProfileTheme.spacingLarge),
                _buildContent(state),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, EditProfileAdminState state) {
    if (state is EditProfileAdminLoaded) {
      nombreController.text = state.admin.nombre;
      apellidoController.text = state.admin.apellido;
      correoController.text = state.admin.correoElectronico;
      cedulaController.text = state.admin.numeroCedula;
    } else if (state is EditProfileAdminSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (state is EditProfileAdminFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${state.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildAvatar(EditProfileAdminState state) {
    String displayName = 'Administrador';
    if (state is EditProfileAdminLoaded) {
      displayName = state.admin.nombre.isNotEmpty ? state.admin.nombre : displayName;
    } else if (nombreController.text.isNotEmpty) {
      displayName = nombreController.text;
    }
    
    return ProfileAvatar(displayName: displayName);
  }

  Widget _buildContent(EditProfileAdminState state) {
    if (state is EditProfileAdminLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return ProfileForm(
      formKey: _formKey,
      nombreController: nombreController,
      apellidoController: apellidoController,
      correoController: correoController,
      cedulaController: cedulaController,
    );
  }
}
