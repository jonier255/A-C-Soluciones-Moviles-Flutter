import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_event.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();

    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            final userRole = state.role.toLowerCase();
            if (userRole == 'admin' || userRole == 'administrador') {
              Navigator.pushReplacementNamed(context, '/admin_home');
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  // curva de arriba
                  ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: 180,
                      color: Color.fromARGB(255, 46, 145, 216),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Logo debajo de la curva azul
                  Image.asset(
                    "assets/soluciones.png",
                    height: 200,
                  ),
                  const SizedBox(height: 8),

                  // este es login como tal, el formulario
                  // aumente el padding horizontal para hacer la tarjeta más angosta
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 46, 145, 216).withOpacity(0.9),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Usuario
                          const Text("Correo electronico"),
                          const SizedBox(height: 8),
                          TextField(
                            controller: loginBloc.emailController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Ingrese su correo electronico",
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 121, 188, 236), width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 121, 188, 236), width: 2.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 121, 188, 236), width: 2.0),
                                )),
                          ),
                          const SizedBox(height: 16),

                          // Contraseña
                          const Text("Contraseña"),
                          const SizedBox(height: 8),
                          TextField(
                            controller: loginBloc.passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Ingresa tu contraseña",
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 121, 188, 236), width: 2.0),
                                ),
                                  
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 121, 188, 236), width: 2.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 121, 188, 236), width: 2.0),
                                )),
                          ),
                          const SizedBox(height: 16),

                          // Olvidaste contraseña y Crear cuenta
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                elevation: 6, // sombra
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // esquinas redondas
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/forget');
                                  },
                                  child: const Text(
                                    "¿Olvidaste la\ncontraseña?",
                                    style: TextStyle(
                                      
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 46, 145, 216),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                
                        
                                elevation: 6, // sombra
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                    child: const Text(
                                      "¿No tienes\ncuenta?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 46, 145, 216),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Boton de iniciar sesion
                          // agregue sombra al boton
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  return state is LoginLoading
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                          onPressed: () {
                                            final email =
                                                loginBloc.emailController.text;
                                            final password = loginBloc
                                                .passwordController.text;
                                            if (email.isNotEmpty &&
                                                password.isNotEmpty) {
                                              loginBloc.add(LoginButtonPressed(
                                                  email: email,
                                                  password: password));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Por favor ingrese correo y contraseña'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50,
                                                      vertical: 15),
                                              backgroundColor: Color.fromARGB(255, 46, 145, 216),
                                              elevation: 8,
                                              shadowColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              )),
                                          child: const Text(
                                            "Iniciar sesión",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// curva de arriba 
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
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Login Successful!'),
      ),
    );
  }
}
