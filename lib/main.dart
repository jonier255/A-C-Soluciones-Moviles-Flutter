import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/client/Chat/chat_page.dart';
import 'package:flutter_a_c_soluciones/ui/client/History/history_page.dart';
import 'package:flutter_a_c_soluciones/ui/client/Home/homeClient.dart';
import 'package:flutter_a_c_soluciones/ui/admin/visits_screen.dart';
import 'package:flutter_a_c_soluciones/ui/client/Requests/requests_page.dart';
import 'package:flutter_a_c_soluciones/ui/client/services/services_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/request/request_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/request_repository.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart'; // Import new repository
import 'package:flutter_a_c_soluciones/ui/login.dart';
import 'package:flutter_a_c_soluciones/ui/registrarse.dart';
import 'package:flutter_a_c_soluciones/ui/splash.dart';
import 'package:flutter_a_c_soluciones/ui/forget.dart';
import 'package:flutter_a_c_soluciones/ui/admin/admin_home.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request_screen.dart';
import 'package:flutter_a_c_soluciones/ui/verifyCode.dart';
import 'package:flutter_a_c_soluciones/ui/technical/technical_home.dart';
import 'package:flutter_a_c_soluciones/ui/technical/view_report_list_page_tc.dart'; // Import new screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => RequestRepository()),
        RepositoryProvider(create: (context) => ReportRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(),
          ),
          BlocProvider(
            create: (context) => RequestBloc(context.read<RequestRepository>()),
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
            '/client_home': (context) => const ClientScreen(),
            '/request': (context) => RequestScreen(),
            '/technical_home': (context) => const TechnicalHomeScreen(),
            '/visits': (context) => VisitsScreen(),
            '/technical_reports': (context) => const ViewReportListPageTc(), // Add new route

            // 🔹 Rutas del Drawer
            '/client_services': (context) => const ServicesPage(),
            '/client_requests': (context) => const RequestsPage(),
            '/client_history': (context) => const HistoryPage(),
            '/client_chat': (context) => const ChatPage(),
          },
        ),
      ),
    );
  }
}
