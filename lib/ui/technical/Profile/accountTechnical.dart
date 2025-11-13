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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
                children: [
                  _buildProfileHeader(userTechnical.nombre, userTechnical.apellido, primaryColor, screenWidth, screenHeight),
                  SizedBox(height: screenHeight * 0.015), // Responsive height
                  _buildInfoCard(userTechnical, textColor, accentColor, screenWidth, screenHeight),
                  SizedBox(height: screenHeight * 0.015), // Responsive height
                  _buildActionButtons(context, primaryColor, accentColor, screenWidth, screenHeight),
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

  Widget _buildProfileHeader(String nombre, String apellido, Color primaryColor, double screenWidth, double screenHeight) {
    return Column(
      children: [
        CircleAvatar(
          radius: screenWidth * 0.18, // Responsive radius
          backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/219/219983.png'),
          backgroundColor: Colors.white,
        ),
        SizedBox(height: screenHeight * 0.015), // Responsive height
        Text(
          '$nombre $apellido',
          style: TextStyle(
            fontSize: screenWidth * 0.065, // Responsive font size
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(dynamic userTechnical, Color textColor, Color accentColor, double screenWidth, double screenHeight) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.025), // Responsive margin
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025, horizontal: screenWidth * 0.025), // Responsive padding
        child: Column(
          children: [
            _buildDetailItem(Icons.person, 'Nombre', userTechnical.nombre, textColor, accentColor, screenWidth),
            Divider(height: screenHeight * 0.012, thickness: 1), // Responsive height
            _buildDetailItem(Icons.person_outline, 'Apellido', userTechnical.apellido, textColor, accentColor, screenWidth),
            Divider(height: screenHeight * 0.012, thickness: 1), // Responsive height
            _buildDetailItem(Icons.credit_card, 'Cédula', userTechnical.numeroCedula, textColor, accentColor, screenWidth),
            Divider(height: screenHeight * 0.012, thickness: 1), // Responsive height
            _buildDetailItem(Icons.phone, 'Teléfono', userTechnical.telefono, textColor, accentColor, screenWidth),
            Divider(height: screenHeight * 0.012, thickness: 1), // Responsive height
            _buildDetailItem(Icons.work, 'Especialidad', userTechnical.especialidad, textColor, accentColor, screenWidth),
            Divider(height: screenHeight * 0.012, thickness: 1), // Responsive height
            _buildDetailItem(Icons.email, 'Correo electrónico', userTechnical.correoElectronico, textColor, accentColor, screenWidth, isEmail: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value, Color textColor, Color accentColor, double screenWidth, {bool isEmail = false}) {
    return ListTile(
      leading: Icon(icon, color: accentColor, size: screenWidth * 0.075), // Responsive icon size
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor.withOpacity(0.7))),
      subtitle: Text(value, style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold, color: textColor)), // Responsive font size
    );
  }

  Widget _buildActionButtons(BuildContext context, Color primaryColor, Color accentColor, double screenWidth, double screenHeight) {
    final editProfileBloc = BlocProvider.of<EditProfileTechnicalBloc>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025), // Responsive horizontal padding
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
              minimumSize: Size(double.infinity, screenHeight * 0.055), // Responsive height
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 5,
            ),
          ),
          SizedBox(height: screenHeight * 0.015), // Responsive height
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
              minimumSize: Size(double.infinity, screenHeight * 0.055), // Responsive height
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}
