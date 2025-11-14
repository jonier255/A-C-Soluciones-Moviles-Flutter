import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/editProfileAdmin/edit_profile_admin_bloc.dart';
import 'package:flutter_a_c_soluciones/model/administrador/admin_model.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final storage = SecureStorageService();
      final token = await storage.getToken();
      final adminId = await storage.getAdminId();
      if (token == null || adminId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token o ID de administrador no encontrados. Por favor inicie sesión.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        context.read<EditProfileAdminBloc>().add(LoadAdminProfile());
      }
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
    const accentBlue = Color(0xFF007BFF);
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<EditProfileAdminBloc, EditProfileAdminState>(
      listener: (context, state) {
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
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF007BFF)),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Volver',
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Image.asset(
                  'assets/logo.png',
                  height: 40,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF007BFF), Colors.teal],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(height: 8),
                              Text(
                                'Perfil',
                                style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Actualiza tu información',
                                style: TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 10),
                Builder(builder: (context) {
                  String displayName = 'Administrador';
                  if (state is EditProfileAdminLoaded) {
                    displayName = state.admin.nombre.isNotEmpty ? state.admin.nombre : displayName;
                  } else if (nombreController.text.isNotEmpty) {
                    displayName = nombreController.text;
                  }
                  final initials = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A';
                  return Transform.translate(
                    offset: const Offset(0, -40),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 6)),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: accentBlue,
                        child: Text(initials, style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  "Editar información personal",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                if (state is EditProfileAdminLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: screenWidth > 700 ? 700 : screenWidth),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(nombreController, "Nombre", icon: Icons.person, accent: accentBlue),
                              const SizedBox(height: 14),
                              _buildTextField(apellidoController, "Apellido", icon: Icons.person_outline, accent: accentBlue),
                              const SizedBox(height: 14),
                              _buildTextField(
                                correoController,
                                "Correo electrónico",
                                keyboardType: TextInputType.emailAddress,
                                icon: Icons.email,
                                accent: accentBlue,
                              ),
                              const SizedBox(height: 14),
                              _buildTextField(
                                cedulaController,
                                "Número de cédula",
                                keyboardType: TextInputType.number,
                                icon: Icons.badge,
                                accent: accentBlue,
                              ),
                              const SizedBox(height: 26),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: accentBlue,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
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
                                            rol: 'admin',
                                          );

                                          context.read<EditProfileAdminBloc>().add(
                                                UpdateAdminProfile(adminData: updatedAdmin),
                                              );
                                        }
                                      },
                                      child: const Text(
                                        "Guardar cambios",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Cancelar",
                                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, IconData? icon, Color? accent}) {
    final useAccent = accent ?? Colors.teal;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: useAccent) : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: useAccent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
    );
  }
}
