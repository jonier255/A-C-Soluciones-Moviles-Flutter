import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/login_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/login_event.dart';
import 'package:flutter_a_c_soluciones/bloc/login_state.dart';
import 'package:flutter_a_c_soluciones/ui/forget.dart';
import 'package:flutter_a_c_soluciones/ui/registrarse.dart';
import 'package:flutter_a_c_soluciones/ui/verifyCode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forget': (context) => const ForgetScreen(),
          '/verify': (context) => const VerifyCodeScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();

    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
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
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Logo debajo de la curva
                  Image.asset(
                    "assets/soluciones.png",
                    height: 200,
                  ),
                  const SizedBox(height: 8),

                  // este es login como tal, el formulario
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Usuario
                          const Text("Correo electronico",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: loginBloc.emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Ingrese su correo electronico",
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Contraseña
                          const Text("Contraseña",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: loginBloc.passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Ingresa tu contraseña",
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Olvidaste contraseña y Crear cuenta
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/forget');
                                },
                                child: const Text(
                                  "¿Olvidaste la contraseña?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: const Text(
                                  "Crear cuenta",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Boton de iniciar sesion
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
                                              minimumSize:
                                                  const Size.fromHeight(50),
                                              backgroundColor: Colors.blue),
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

/// curva de arriba la logica
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
