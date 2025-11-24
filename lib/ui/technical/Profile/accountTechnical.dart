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
    const primaryColor = Color(0xFF0D47A1); // Dark Blue
    const backgroundColor = Color(0xFFF5F5F5); // Light Gray
    const accentColor = Color(0xFFFFC107); // Amber

    return BlocProvider(
      create: (context) => EditProfileTechnicalBloc(
        technicalUpdateProfileRepository: TechnicalUpdateProfileRepository(),
      )..add(LoadTechnicalProfile()),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'Mi Perfil',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: BlocBuilder<EditProfileTechnicalBloc, EditProfileTechnicalState>(
          builder: (context, state) {
            if (state is EditProfileTechnicalLoading || state is EditProfileTechnicalSuccess) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EditProfileTechnicalLoaded) {
              final userTechnical = state.technical;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
                child: Column(
                  children: [
                    // Card con foto y nombre
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE3F2FD), Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * 0.10,
                              backgroundImage: const NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/219/219983.png',
                              ),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Expanded(
                              child: Text(
                                '${userTechnical.nombre} ${userTechnical.apellido}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.048,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.012),

                    // Card con información personal
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.blue[700], size: 22),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  'Información Personal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.012),
                            _buildDetailRow(Icons.person, 'Nombre', userTechnical.nombre, screenWidth, screenHeight),
                            SizedBox(height: screenHeight * 0.008),
                            _buildDetailRow(Icons.person_outline, 'Apellido', userTechnical.apellido, screenWidth, screenHeight),
                            SizedBox(height: screenHeight * 0.008),
                            _buildDetailRow(Icons.credit_card, 'Cédula', userTechnical.numeroCedula, screenWidth, screenHeight),
                            SizedBox(height: screenHeight * 0.008),
                            _buildDetailRow(Icons.phone, 'Teléfono', userTechnical.telefono, screenWidth, screenHeight),
                            SizedBox(height: screenHeight * 0.008),
                            _buildDetailRow(Icons.work, 'Especialidad', userTechnical.especialidad, screenWidth, screenHeight),
                            SizedBox(height: screenHeight * 0.008),
                            _buildDetailRow(Icons.email, 'Correo', userTechnical.correoElectronico, screenWidth, screenHeight),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.012),

                    // Botones de acción
                    _buildActionButtons(context, primaryColor, accentColor, screenWidth, screenHeight),
                  ],
                ),
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

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.008),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700], size: screenWidth * 0.045),
          SizedBox(width: screenWidth * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.032,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value.isNotEmpty ? value : '—',
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Color primaryColor, Color accentColor, double screenWidth, double screenHeight) {
    final editProfileBloc = BlocProvider.of<EditProfileTechnicalBloc>(context);
    return Row(
      children: [
        // Botón Editar
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.blue[400]!],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              icon: Icon(Icons.edit, color: Colors.white, size: screenWidth * 0.045),
              label: Text(
                'Editar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.038,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: editProfileBloc,
                      child: const EditarInformacionScreenTechnical(),
                    ),
                  ),
                );

                if (result == true && context.mounted) {
                  editProfileBloc.add(LoadTechnicalProfile());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: Size(double.infinity, screenHeight * 0.055),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        // Botón Cerrar Sesión
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: OutlinedButton.icon(
              icon: Icon(Icons.logout, color: Colors.red, size: screenWidth * 0.045),
              label: Text(
                'Salir',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: screenWidth * 0.038,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                final secureStorage = SecureStorageService();
                await secureStorage.clearAll();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide.none,
                minimumSize: Size(double.infinity, screenHeight * 0.055),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}