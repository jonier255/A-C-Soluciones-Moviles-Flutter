import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/editProfileTechnical/edit_profile_technical_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/services_technical/service_TechnicalUpdateProfile.dart';
import 'package:flutter_a_c_soluciones/ui/login.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Profile/updateProfileTechnical.dart';

class AccountTechnicalScreen extends StatefulWidget {
  const AccountTechnicalScreen({super.key});

  @override
  State<AccountTechnicalScreen> createState() => _AccountTechnicalScreenState();
}

class _AccountTechnicalScreenState extends State<AccountTechnicalScreen> {
  @override
  Widget build(BuildContext context) {
    // Define colors for a cleaner look
    final primaryColor = Color(0xFF0D47A1); // Dark Blue
    final backgroundColor = Color(0xFFF5F5F5); // Light Gray
    final accentColor = Color(0xFFFFC107); // Amber
    final textColor = Color(0xFF212121); // Dark Gray

    return BlocProvider(
      create: (context) => EditProfileTechnicalBloc(
        technicalUpdateProfileRepository: TechnicalUpdateProfileRepository(),
      )..add(LoadTechnicalProfile()),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('Mi Perfil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        body: BlocBuilder<EditProfileTechnicalBloc, EditProfileTechnicalState>(
          builder: (context, state) {
            if (state is EditProfileTechnicalLoading || state is EditProfileTechnicalSuccess) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EditProfileTechnicalLoaded) {
              final userTechnical = state.technical;
              return ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  _buildProfileHeader(userTechnical.nombre, userTechnical.apellido, primaryColor),
                  const SizedBox(height: 15),
                  _buildInfoCard(userTechnical, textColor, accentColor),
                  const SizedBox(height: 15),
                  _buildActionButtons(context, primaryColor, accentColor),
                ],
              );
            } else if (state is EditProfileTechnicalFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const Center(child: Text('Cargando datos del perfil...'));
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String nombre, String apellido, Color primaryColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/219/219983.png'),
          backgroundColor: Colors.white,
        ),
        const SizedBox(height: 15),
        Text(
          '$nombre $apellido',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(dynamic userTechnical, Color textColor, Color accentColor) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            _buildDetailItem(Icons.person, 'Nombre', userTechnical.nombre, textColor, accentColor),
            const Divider(height: 10, thickness: 1),
            _buildDetailItem(Icons.person_outline, 'Apellido', userTechnical.apellido, textColor, accentColor),
            const Divider(height: 10, thickness: 1),
            _buildDetailItem(Icons.credit_card, 'Cédula', userTechnical.numeroCedula, textColor, accentColor),
            const Divider(height: 10, thickness: 1),
            _buildDetailItem(Icons.phone, 'Teléfono', userTechnical.telefono, textColor, accentColor),
            const Divider(height: 10, thickness: 1),
            _buildDetailItem(Icons.work, 'Especialidad', userTechnical.especialidad, textColor, accentColor),
            const Divider(height: 10, thickness: 1),
            _buildDetailItem(Icons.email, 'Correo electrónico', userTechnical.correoElectronico, textColor, accentColor, isEmail: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value, Color textColor, Color accentColor, {bool isEmail = false}) {
    return ListTile(
      leading: Icon(icon, color: accentColor, size: 30),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor.withOpacity(0.7))),
      subtitle: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
    );
  }

  Widget _buildActionButtons(BuildContext context, Color primaryColor, Color accentColor) {
    final editProfileBloc = BlocProvider.of<EditProfileTechnicalBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.edit, color: Colors.white),
            label: const Text('Editar Información'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: editProfileBloc,
                    child: const EditarInformacionScreenTechnical(),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 5,
            ),
          ),
          const SizedBox(height: 15),
          OutlinedButton.icon(
            icon: Icon(Icons.logout, color: Colors.red),
            label: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              final secureStorage = SecureStorageService();
              await secureStorage.clearAll();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}
