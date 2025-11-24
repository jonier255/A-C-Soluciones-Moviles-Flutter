import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/client/edit_profile_client_bloc.dart';
import 'package:flutter_a_c_soluciones/model/client/client_profile_model.dart';
import 'package:flutter_a_c_soluciones/repository/secure_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileClientScreen extends StatefulWidget {
  const EditProfileClientScreen({super.key});

  @override
  State<EditProfileClientScreen> createState() => _EditProfileClientScreenState();
}

class _EditProfileClientScreenState extends State<EditProfileClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numeroCedulaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _contraseniaController = TextEditingController();
  final TextEditingController _confirmarContraseniaController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _cambiarContrasenia = false;

  @override
  void initState() {
    super.initState();
    _loadInitialDataFromLogin();
    context.read<EditProfileClientBloc>().add(LoadClientProfile());
  }

  Future<void> _loadInitialDataFromLogin() async {
    // Cargar datos iniciales del login desde SecureStorage
    final storage = SecureStorageService();
    final clienteIdStr = await storage.getUserData('cliente_id');
    final userName = await storage.getUserData('user_name');
    final userEmail = await storage.getUserData('user_email');
    
    // Inicializar campos con datos del login
    if (mounted) {
      setState(() {
        if (userName != null && userName.isNotEmpty) {
          _nombreController.text = userName;
        }
        if (userEmail != null && userEmail.isNotEmpty) {
          _correoController.text = userEmail;
        }
      });
    }
  }

  @override
  void dispose() {
    _numeroCedulaController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _contraseniaController.dispose();
    _confirmarContraseniaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1024;

    return BlocConsumer<EditProfileClientBloc, EditProfileClientState>(
      listener: (context, state) {
        if (state is EditProfileClientLoaded) {
          _numeroCedulaController.text = state.client.numeroDeCedula;
          _nombreController.text = state.client.nombre;
          _apellidoController.text = state.client.apellido;
          _correoController.text = state.client.correoElectronico;
          _telefonoController.text = state.client.telefono;
          _direccionController.text = state.client.direccion;
        } else if (state is EditProfileClientSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Perfil actualizado correctamente'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.pop(context, true);
        } else if (state is EditProfileClientFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is EditProfileClientLoading && state is! EditProfileClientLoaded;
        
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: const Color(0xFF2E91D8),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Editar Perfil',
              style: TextStyle(
                fontSize: isTablet ? 22 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E91D8)),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? (isDesktop ? 40 : 30) : 20,
                    vertical: 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header con icono
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2E91D8),
                                Color(0xFF56AFEC),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 50,
                                  color: Color(0xFF2E91D8),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Información Personal',
                                style: TextStyle(
                                  fontSize: isTablet ? 22 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Formulario
                        Container(
                          padding: EdgeInsets.all(isTablet ? 24 : 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildTextField(
                                controller: _numeroCedulaController,
                                label: 'Número de Cédula',
                                icon: Icons.badge_rounded,
                                keyboardType: TextInputType.number,
                                isTablet: isTablet,
                                validator: _validateCedula,
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              _buildTextField(
                                controller: _nombreController,
                                label: 'Nombre',
                                icon: Icons.person_rounded,
                                isTablet: isTablet,
                                validator: _validateNombre,
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              _buildTextField(
                                controller: _apellidoController,
                                label: 'Apellido',
                                icon: Icons.person_outline_rounded,
                                isTablet: isTablet,
                                validator: _validateApellido,
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              _buildTextField(
                                controller: _correoController,
                                label: 'Correo Electrónico',
                                icon: Icons.email_rounded,
                                keyboardType: TextInputType.emailAddress,
                                isTablet: isTablet,
                                validator: _validateEmail,
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              _buildTextField(
                                controller: _telefonoController,
                                label: 'Teléfono',
                                icon: Icons.phone_rounded,
                                keyboardType: TextInputType.phone,
                                isTablet: isTablet,
                                validator: _validateTelefono,
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                              _buildTextField(
                                controller: _direccionController,
                                label: 'Dirección',
                                icon: Icons.location_on_rounded,
                                maxLines: 3,
                                isTablet: isTablet,
                                validator: _validateDireccion,
                              ),
                              SizedBox(height: isTablet ? 24 : 20),
                              
                              // Checkbox para cambiar contraseña
                              Row(
                                children: [
                                  Checkbox(
                                    value: _cambiarContrasenia,
                                    onChanged: (value) {
                                      setState(() {
                                        _cambiarContrasenia = value ?? false;
                                        if (!_cambiarContrasenia) {
                                          _contraseniaController.clear();
                                          _confirmarContraseniaController.clear();
                                        }
                                      });
                                    },
                                    activeColor: const Color(0xFF2E91D8),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Cambiar contraseña',
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              if (_cambiarContrasenia) ...[
                                SizedBox(height: isTablet ? 20 : 16),
                                _buildPasswordField(
                                  controller: _contraseniaController,
                                  label: 'Nueva Contraseña',
                                  obscureText: _obscurePassword,
                                  onToggleVisibility: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  isTablet: isTablet,
                                  validator: _validatePassword,
                                ),
                                SizedBox(height: isTablet ? 20 : 16),
                                _buildPasswordField(
                                  controller: _confirmarContraseniaController,
                                  label: 'Confirmar Contraseña',
                                  obscureText: _obscureConfirmPassword,
                                  onToggleVisibility: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                  isTablet: isTablet,
                                  validator: (value) {
                                    if (_cambiarContrasenia) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor confirme la contraseña';
                                      }
                                      if (value != _contraseniaController.text) {
                                        return 'Las contraseñas no coinciden';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              
                              SizedBox(height: isTablet ? 32 : 24),
                              
                              // Botones
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        foregroundColor: Colors.black87,
                                        padding: EdgeInsets.symmetric(
                                          vertical: isTablet ? 16 : 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Text(
                                        'Cancelar',
                                        style: TextStyle(
                                          fontSize: isTablet ? 16 : 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: isTablet ? 16 : 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          if (state is EditProfileClientLoaded) {
                                            final clientData = ClientProfileModel(
                                              id: state.client.id,
                                              numeroDeCedula: _numeroCedulaController.text.trim(),
                                              nombre: _nombreController.text.trim(),
                                              apellido: _apellidoController.text.trim(),
                                              correoElectronico: _correoController.text.trim(),
                                              telefono: _telefonoController.text.trim(),
                                              direccion: _direccionController.text.trim(),
                                              contrasenia: _cambiarContrasenia && _contraseniaController.text.isNotEmpty
                                                  ? _contraseniaController.text
                                                  : null,
                                              rol: state.client.rol,
                                              estado: state.client.estado,
                                            );
                                            context.read<EditProfileClientBloc>().add(
                                                  UpdateClientProfile(clientData: clientData),
                                                );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2E91D8),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          vertical: isTablet ? 16 : 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Text(
                                        'Guardar Cambios',
                                        style: TextStyle(
                                          fontSize: isTablet ? 16 : 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isTablet ? 24 : 20),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required bool isTablet,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(fontSize: isTablet ? 16 : 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2E91D8)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E91D8), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 16,
          vertical: isTablet ? 18 : 16,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required bool isTablet,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(fontSize: isTablet ? 16 : 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFF2E91D8)),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            color: Colors.grey.shade600,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E91D8), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 16,
          vertical: isTablet ? 18 : 16,
        ),
      ),
      validator: validator,
    );
  }

  // Validaciones según las reglas del backend
  String? _validateCedula(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número de cédula es requerido';
    }
    final trimmed = value.trim();
    if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
      return 'La cédula debe contener solo números';
    }
    if (trimmed.length < 6 || trimmed.length > 10) {
      return 'La cédula debe tener entre 6 y 10 dígitos';
    }
    if (trimmed.startsWith('0')) {
      return 'La cédula no debe comenzar con cero';
    }
    const sequences = ['123456', '1234567', '12345678', '123456789', '111111', '1111111', '11111111', '111111111'];
    if (sequences.any((seq) => trimmed.startsWith(seq))) {
      return 'La cédula no debe ser una secuencia numérica predecible';
    }
    return null;
  }

  String? _validateNombre(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }
    final trimmed = value.trim();
    if (trimmed.length > 50) {
      return 'El nombre no debe exceder los 50 caracteres';
    }
    if (trimmed != value) {
      return 'El nombre no debe tener espacios al inicio o final';
    }
    if (!RegExp(r'^[a-záéíóúñ\s]*$', caseSensitive: false).hasMatch(trimmed)) {
      return 'El nombre solo puede contener letras y espacios';
    }
    if (RegExp(r'(.)\1{3,}').hasMatch(trimmed)) {
      return 'No se permiten repeticiones excesivas de caracteres';
    }
    if (RegExp(r'\s{2,}').hasMatch(trimmed)) {
      return 'No se permiten espacios múltiples consecutivos';
    }
    return null;
  }

  String? _validateApellido(String? value) {
    if (value == null || value.isEmpty) {
      return 'El apellido es requerido';
    }
    final trimmed = value.trim();
    if (trimmed.length > 50) {
      return 'El apellido no debe exceder los 50 caracteres';
    }
    if (trimmed != value) {
      return 'El apellido no debe tener espacios al inicio o final';
    }
    if (!RegExp(r'^[a-záéíóúñ\s]*$', caseSensitive: false).hasMatch(trimmed)) {
      return 'El apellido solo puede contener letras y espacios';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    final trimmed = value.trim();
    if (trimmed.length < 5 || trimmed.length > 320) {
      return 'El correo debe tener entre 5 y 320 caracteres';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(trimmed)) {
      return 'El correo electrónico tiene un formato incorrecto';
    }
    return null;
  }

  String? _validateTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }
    final trimmed = value.trim();
    if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
      return 'El número de teléfono solo puede contener números';
    }
    if (trimmed.length != 10) {
      return 'El teléfono debe tener exactamente 10 dígitos';
    }
    if (!trimmed.startsWith('3')) {
      return 'El teléfono debe iniciar con 3 en Colombia';
    }
    return null;
  }

  String? _validateDireccion(String? value) {
    if (value == null || value.isEmpty) {
      return 'La dirección es requerida';
    }
    final trimmed = value.trim();
    if (trimmed.length < 10 || trimmed.length > 255) {
      return 'La dirección debe tener entre 10 y 255 caracteres';
    }
    if (trimmed.isEmpty) {
      return 'La dirección no puede estar vacía';
    }
    if (RegExp(r'^\s+$').hasMatch(trimmed)) {
      return 'La dirección no puede contener solo espacios';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (!_cambiarContrasenia) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 8 || value.length > 64) {
      return 'La contraseña debe tener entre 8 y 64 caracteres';
    }
    if (value.contains(' ')) {
      return 'La contraseña no puede contener espacios';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_\-+=])[^\s]{8,64}$').hasMatch(value)) {
      return 'La contraseña debe incluir mayúscula, minúscula, número y carácter especial';
    }
    const commonPasswords = ['123456', 'abcdef', 'qwerty', '12345678', '111111'];
    if (commonPasswords.contains(value)) {
      return 'La contraseña no puede ser común o predecible';
    }
    return null;
  }
}

