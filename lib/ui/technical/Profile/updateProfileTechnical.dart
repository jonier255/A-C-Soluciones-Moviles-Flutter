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

  Map<String, String> _fieldErrors = {};
  Map<String, String> _originalValues = {};
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    context.read<EditProfileTechnicalBloc>().add(LoadTechnicalProfile());

    void addListener(TextEditingController controller, String key) {
      controller.addListener(() {
        if (_fieldErrors.containsKey(key)) {
          setState(() {
            _fieldErrors.remove(key);
          });
        }
        _checkForChanges();
      });
    }

    addListener(nombreController, 'nombre');
    addListener(apellidoController, 'apellido');
    addListener(correoController, 'correo_electronico');
    addListener(telefonoController, 'telefono');
  }

  void _checkForChanges() {
    final hasChanged = nombreController.text != _originalValues['nombre'] ||
        apellidoController.text != _originalValues['apellido'] ||
        correoController.text != _originalValues['correo_electronico'] ||
        telefonoController.text != _originalValues['telefono'];
    if (hasChanged != _hasChanges) {
      setState(() {
        _hasChanges = hasChanged;
      });
    }
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
    final primaryColor = Color(0xFF0D47A1);
    final backgroundColor = Color(0xFFF5F5F5);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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

            _originalValues = {
              'nombre': state.technical.nombre,
              'apellido': state.technical.apellido,
              'correo_electronico': state.technical.correoElectronico,
              'telefono': state.technical.telefono,
            };
            _checkForChanges();

          } else if (state is EditProfileTechnicalSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Perfil actualizado correctamente'),
                backgroundColor: Colors.green,
              ),
            );
            // Pop screen and return true to signal success
            Navigator.of(context).pop(true);
          } else if (state is EditProfileTechnicalFailure) {
            if (state.fieldErrors != null) {
              setState(() {
                _fieldErrors = state.fieldErrors!;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final isSubmitting = state is EditProfileTechnicalLoading;
          if (state is EditProfileTechnicalInitial || (state is EditProfileTechnicalLoaded && nombreController.text.isEmpty)) {
             return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(screenWidth * 0.05),
              children: [
                _buildTextField(nombreController, "Nombre", Icons.person, primaryColor, errorText: _fieldErrors['nombre']),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(apellidoController, "Apellido", Icons.person_outline, primaryColor, errorText: _fieldErrors['apellido']),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  correoController,
                  "Correo electrónico",
                  Icons.email,
                  primaryColor,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _fieldErrors['correo_electronico'],
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  telefonoController,
                  "Teléfono",
                  Icons.phone,
                  primaryColor,
                  keyboardType: TextInputType.phone,
                  errorText: _fieldErrors['telefono'],
                ),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton.icon(
                  icon: Icon(Icons.save, color: Colors.white),
                  label: Text(isSubmitting ? 'Guardando...' : 'Guardar Cambios'),
                  onPressed: (isSubmitting || !_hasChanges) ? null : () {
                    setState(() {
                      _fieldErrors = {};
                    });
                    if (_formKey.currentState!.validate()) {
                      final updatedTechnical = UpdateTechnicalRequest(
                        id: 0,
                        nombre: nombreController.text,
                        apellido: apellidoController.text,
                        numeroCedula: numeroCedula,
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
                    disabledBackgroundColor: Colors.grey,
                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                OutlinedButton.icon(
                  icon: Icon(Icons.cancel, color: Colors.grey[600]),
                  label: Text('Cancelar', style: TextStyle(color: Colors.grey[600])),
                  onPressed: () {
                    // Reset the BLoC state by reloading the profile before popping.
                    context.read<EditProfileTechnicalBloc>().add(LoadTechnicalProfile());
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[400]!),
                    minimumSize: Size(double.infinity, screenHeight * 0.06),
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
      {TextInputType keyboardType = TextInputType.text, String? errorText}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.red, width: 2),
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