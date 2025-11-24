import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_event.dart';
import 'package:flutter_a_c_soluciones/bloc/register/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: BlocProvider(
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
            child: Stack(
              children: [
                /// Fondo curvo azul superior
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      color: const Color.fromARGB(255, 46, 145, 216),
                    ),
                  ),
                ),

                
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 130),

                        /// Imagen de perfil
                        Image.asset("assets/profile.png", height: 90),
                        const SizedBox(height: 10),

                        /// Tarjeta del  formulario
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 15, 128, 209)
                                      .withValues(alpha: 0.9),
                                  spreadRadius: 2,
                                  blurRadius: 18,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInput("Nombres", "Ingresa tus nombres",
                                    _registerBloc.nombreController),
                                const SizedBox(height: 3),
                                _buildInput("Apellidos", "Ingresa tus apellidos",
                                    _registerBloc.apellidoController),
                                const SizedBox(height: 3),
                                _buildInput(
                                    "Correo electrónico",
                                    "Ingresa tu correo",
                                    _registerBloc
                                        .correoElectronicoController),
                                const SizedBox(height: 3),
                                _buildInput(
                                    "Contraseña",
                                    "Ingresa tu contraseña",
                                    _registerBloc.contraseniaController,
                                    obscure: true),
                                const SizedBox(height: 3),
                                _buildInput(
                                    "Cédula",
                                    "Ingresa tu número de cédula",
                                    _registerBloc.numeroDeCedulaController),
                                const SizedBox(height: 3),
                                _buildInput("Teléfono", "Ingresa tu teléfono",
                                    _registerBloc.telefonoController),
                                const SizedBox(height: 3),
                                _buildInput("Dirección", "Ingresa tu dirección",
                                    _registerBloc.direccionController),
                                const SizedBox(height: 10),
                                Center(
                                  child: BlocBuilder<RegisterBloc,
                                      RegisterState>(
                                    builder: (context, state) {
                                      if (state is RegisterLoading) {
                                        return const CircularProgressIndicator();
                                      }
                                      return ElevatedButton(
                                        onPressed: () {
                                          _registerBloc.add(
                                            RegisterButtonPressed(
                                              nombre: _registerBloc
                                                  .nombreController.text,
                                              apellido: _registerBloc
                                                  .apellidoController.text,
                                              numeroDeCedula: _registerBloc
                                                  .numeroDeCedulaController.text,
                                              correoElectronico: _registerBloc
                                                  .correoElectronicoController
                                                  .text,
                                              telefono: _registerBloc
                                                  .telefonoController.text,
                                              direccion: _registerBloc
                                                  .direccionController.text,
                                              contrasenia: _registerBloc
                                                  .contraseniaController.text,
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 12),
                                          backgroundColor:
                                              const Color.fromARGB(
                                                  255, 15, 128, 209),
                                          elevation: 8,
                                          shadowColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          "Registrarse",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                //Boton de atras
                Positioned(
                  top: 10,
                  left: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 28),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.of(context, rootNavigator: true).maybePop();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, String hint, TextEditingController controller,
      {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 112, 184, 235),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 112, 184, 235),
                width: 2.0,
              ),
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

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
