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
  String numeroCedula = '';

  @override
  void initState() {
    super.initState();
    context.read<EditProfileTechnicalBloc>().add(LoadTechnicalProfile());
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    correoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileTechnicalBloc, EditProfileTechnicalState>(
      listener: (context, state) {
        if (state is EditProfileTechnicalLoaded) {
          nombreController.text = state.technical.nombre;
          apellidoController.text = state.technical.apellido;
          correoController.text = state.technical.correoElectronico;
          numeroCedula = state.technical.numeroCedula;
        } else if (state is EditProfileTechnicalSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil actualizado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
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
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BFF),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Volver",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
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
                const SizedBox(height: 10),
                const Icon(Icons.account_circle, size: 90, color: Colors.teal),
                const SizedBox(height: 20),
                const Text(
                  "Editar información personal",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                if (state is EditProfileTechnicalLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(nombreController, "Nombre"),
                          const SizedBox(height: 15),
                          _buildTextField(apellidoController, "Apellido"),
                          const SizedBox(height: 15),
                          _buildTextField(
                            correoController,
                            "Correo electrónico",
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF007BFF),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 5,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final updatedTechnical = UpdateTechnicalRequest(
                                      id: 0,
                                      nombre: nombreController.text,
                                      apellido: apellidoController.text,
                                      numeroCedula: numeroCedula,
                                      correoElectronico: correoController.text,
                                      rol: 'technical',
                                    );
                                    context.read<EditProfileTechnicalBloc>().add(
                                          UpdateTechnicalProfile(technicalData: updatedTechnical),
                                        );
                                  }
                                },
                                child: const Text(
                                  "Guardar cambios",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 5,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        ],
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
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(6),
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
