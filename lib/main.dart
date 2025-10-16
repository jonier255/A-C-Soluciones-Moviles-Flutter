import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/client/Home/homeClient.dart';
import 'package:flutter_a_c_soluciones/ui/admin/visits_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/request/request_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/request_repository.dart';
import 'package:flutter_a_c_soluciones/ui/login.dart';
import 'package:flutter_a_c_soluciones/ui/registrarse.dart';
import 'package:flutter_a_c_soluciones/ui/splash.dart';
import 'package:flutter_a_c_soluciones/ui/forget.dart';
import 'package:flutter_a_c_soluciones/ui/admin/admin_home.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request_screen.dart';
import 'package:flutter_a_c_soluciones/ui/verifyCode.dart';

import 'ui/client/Chat/chat_page.dart';
import 'ui/client/History/history_page.dart';
import 'ui/client/Requests/requests_page.dart';
import 'ui/client/services/services_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => RequestBloc(RequestRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/splash",
        routes: {
          "/splash": (context) => const SplashScreen(),
          "/login": (context) => const LoginScreen(),
          "/register": (context) => const RegisterScreen(),
          '/forget': (context) => const ForgetScreen(),
          '/verify': (context) => VerifyCodeScreen(),
          '/admin_home': (context) => const AdminHomeScreen(),
          '/request': (context) => RequestScreen(),
          '/visits': (context) => VisitsScreen(),

          // 🔹 Rutas del Drawer
          '/client_home': (context) => const ClientScreen(),
          '/client_services': (context) => const ServicesPage(),
          '/client_requests': (context) => const RequestsPage(),
          '/client_history': (context) => const HistoryPage(),
          '/client_chat': (context) => const ChatPage(),
        },
      ),
    );
  }
}
