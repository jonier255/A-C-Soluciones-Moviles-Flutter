import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/login_bloc.dart';
import 'package:flutter_a_c_soluciones/ui/login.dart';
import 'package:flutter_a_c_soluciones/ui/registrarse.dart';
import 'package:flutter_a_c_soluciones/ui/splash.dart';
import 'package:flutter_a_c_soluciones/ui/forget.dart';
import 'package:flutter_a_c_soluciones/ui/verifyCode.dart';

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
        initialRoute: "/splash",
        routes: {
          "/splash": (context) => const SplashScreen(),
          "/login": (context) => const LoginScreen(),
          "/register": (context) => const RegisterScreen(),
          '/forget': (context) => const ForgetScreen(),
          '/verify': (context) => const VerifyCodeScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}