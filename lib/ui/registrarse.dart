import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/register_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/register_event.dart';
import 'package:flutter_a_c_soluciones/bloc/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = RegisterBloc();
  }

  @override
  void dispose() {
    _registerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _registerBloc,
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pop(context);
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 15, 128, 209),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Volver",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Image.asset(
                        "assets/soluciones.png",
                        height: 80,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Image.asset(
                      'assets/user.png',
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 15, 128, 209).withOpacity(0.9),
                            spreadRadius: 2,
                            blurRadius: 18,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInput("Nombres", "Ingresa tus nombres", _registerBloc.nombreController),
                          const SizedBox(height: 16),
                          _buildInput("Apellidos", "Ingresa tus apellidos", _registerBloc.apellidoController),
                          const SizedBox(height: 16),
                          _buildInput("Correo electrónico", "Ingresa tu correo", _registerBloc.correoElectronicoController),
                          const SizedBox(height: 16),
                          _buildInput("Contraseña", "Ingresa tu contraseña", _registerBloc.contraseniaController, obscure: true),
                          const SizedBox(height: 16),
                          _buildInput("Cédula", "Ingresa tu número de cédula", _registerBloc.numeroDeCedulaController),
                          const SizedBox(height: 16),
                          _buildInput("Teléfono", "Ingresa tu teléfono", _registerBloc.telefonoController),
                          const SizedBox(height: 16),
                          _buildInput("Dirección", "Ingresa tu dirección", _registerBloc.direccionController),
                          const SizedBox(height: 20),
                          BlocBuilder<RegisterBloc, RegisterState>(
                            builder: (context, state) {
                              if (state is RegisterLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              return Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _registerBloc.add(
                                      RegisterButtonPressed(
                                        nombre: _registerBloc.nombreController.text,
                                        apellido: _registerBloc.apellidoController.text,
                                        numero_de_cedula: _registerBloc.numeroDeCedulaController.text,
                                        correo_electronico: _registerBloc.correoElectronicoController.text,
                                        telefono: _registerBloc.telefonoController.text,
                                        direccion: _registerBloc.direccionController.text,
                                        contrasenia: _registerBloc.contraseniaController.text,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                    backgroundColor: Color.fromARGB(255, 15, 128, 209),
                                    // Se agrega la elevación para la sombra
                                    elevation: 8,
                                    // Se agrega el color de la sombra
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Registrarse",
                                    style: TextStyle(
                                        fontSize: 16, 
                                        color: Colors.white, 
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, String hint, TextEditingController controller, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Se ha quitado la negrilla del texto de la etiqueta
        Text(label, style: const TextStyle()),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color.fromARGB(255, 112, 184, 235), width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color.fromARGB(255, 112, 184, 235), width: 2.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color.fromARGB(255, 112, 184, 235), width: 2.0),
          ),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ],
  );
}
}