import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/editProfileTechnical/edit_profile_technical_bloc.dart';
import 'package:flutter_a_c_soluciones/model/technical/technical_model.dart';

class EditarInformacionScreenTechnical extends StatefulWidget {
  const EditarInformacionScreenTechnical({super.key});

  @override
  State<EditarInformacionScreenTechnical> createState() => _EditarInformacionScreenTechnicalState();
}

class _EditarInformacionScreenTechnicalState extends State<EditarInformacionScreenTechnical> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  String numeroCedula = '';
  String especialidad = '';

  @override
  void initState() {
    super.initState();
    // The BLoC is provided by the previous screen, so we can access it directly.
    context.read<EditProfileTechnicalBloc>().add(LoadTechnicalProfile());
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF0D47A1); // Dark Blue
    final backgroundColor = Color(0xFFF5F5F5); // Light Gray

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Editar Perfil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<EditProfileTechnicalBloc, EditProfileTechnicalState>(
        listener: (context, state) {
          if (state is EditProfileTechnicalLoaded) {
            nombreController.text = state.technical.nombre;
            apellidoController.text = state.technical.apellido;
            correoController.text = state.technical.correoElectronico;
            telefonoController.text = state.technical.telefono;
            numeroCedula = state.technical.numeroCedula;
            especialidad = state.technical.especialidad;
          } else if (state is EditProfileTechnicalSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Perfil actualizado correctamente'),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
          } else if (state is EditProfileTechnicalFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is EditProfileTechnicalLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                _buildTextField(nombreController, "Nombre", Icons.person, primaryColor),
                const SizedBox(height: 20),
                _buildTextField(apellidoController, "Apellido", Icons.person_outline, primaryColor),
                const SizedBox(height: 20),
                _buildTextField(
                  correoController,
                  "Correo electrónico",
                  Icons.email,
                  primaryColor,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  telefonoController,
                  "Teléfono",
                  Icons.phone,
                  primaryColor,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.save, color: Colors.white),
                  label: const Text('Guardar Cambios'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedTechnical = UpdateTechnicalRequest(
                        id: 0, // The ID is not editable, but required by the model
                        nombre: nombreController.text,
                        apellido: apellidoController.text,
                        numeroCedula: numeroCedula, // Not editable, passed from initial state
                        correoElectronico: correoController.text,
                        telefono: telefonoController.text,
                        especialidad: especialidad,
                        rol: 'tecnico',
                      );
                      context.read<EditProfileTechnicalBloc>().add(
                            UpdateTechnicalProfile(technicalData: updatedTechnical),
                          );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                  ),
                ),
                const SizedBox(height: 15),
                OutlinedButton.icon(
                  icon: Icon(Icons.cancel, color: Colors.grey[600]),
                  label: Text('Cancelar', style: TextStyle(color: Colors.grey[600])),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[400]!),
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, Color primaryColor,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor, width: 2),
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
