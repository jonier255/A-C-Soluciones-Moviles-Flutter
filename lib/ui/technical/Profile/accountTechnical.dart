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
  void initState() {
    super.initState();
    // Assuming EditProfileTechnicalBloc is provided higher up in the widget tree
    // If not, you would need to provide it here.
    // For demonstration, let's assume it's provided.
    // If you need to create it here, you would do it in the build method with a BlocProvider.
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileTechnicalBloc(
        technicalUpdateProfileRepository: TechnicalUpdateProfileRepository(),
      )..add(LoadTechnicalProfile()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Perfil del Técnico'),
          backgroundColor: const Color.fromARGB(255, 46, 145, 216),
        ),
        body: BlocBuilder<EditProfileTechnicalBloc, EditProfileTechnicalState>(
          builder: (context, state) {
            if (state is EditProfileTechnicalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EditProfileTechnicalLoaded) {
              final userTechnical = state.technical;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/219/219983.png'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            '${userTechnical.nombre} ${userTechnical.apellido}',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildDetailItem('Cédula', userTechnical.numeroCedula),
                    _buildDetailItem('Nombre', userTechnical.nombre),
                    _buildDetailItem('Apellido', userTechnical.apellido),
                    _buildDetailItem('Correo electrónico', userTechnical.correoElectronico, isEmail: true),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => EditProfileTechnicalBloc(
                                technicalUpdateProfileRepository:
                                    TechnicalUpdateProfileRepository(),
                              ),
                              child: const EditarInformacionScreenTechnical(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Editar información personal'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final secureStorage = SecureStorageService();
                        await secureStorage.clearAll();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Cerrar Sesión'),
                    ),
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

  Widget _buildDetailItem(String title, String value, {bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          isEmail
              ? SelectableText(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                  onTap: () {
                    // Handle email tap if needed, e.g., launch email client
                  },
                )
              : Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }
}
