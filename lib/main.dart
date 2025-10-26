import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/admin/visits_screen.dart';
import 'package:flutter_a_c_soluciones/ui/client/layout.dart';
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
import 'package:flutter_a_c_soluciones/ui/technical/screens/technical_home.dart';
import 'package:flutter_a_c_soluciones/ui/technical/screens/view_report_list_page_tc.dart'; // Import new screen
import 'package:flutter_a_c_soluciones/ui/technical/screens/assigned_visits_screen.dart';
import 'package:flutter_a_c_soluciones/ui/technical/screens/services_screen.dart';
import 'package:flutter_a_c_soluciones/ui/technical/screens/completed_visits_screen.dart';

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
            '/request': (context) => RequestScreen(),
            '/technical_home': (context) => const TechnicalHomeScreen(),
            '/visits': (context) => VisitsScreen(),
            '/technical_reports': (context) => const ViewReportListPageTc(), // Add new route
            '/technical_assigned_visits': (context) => const AssignedVisitsScreen(),
            '/technical_services': (context) => const ServicesScreen(),
            '/technical_completed_visits': (context) => const CompletedVisitsScreen(),

            // En tu main.dart, actualiza la ruta:
            '/client_home': (context) => const ClientLayout(),
          },
        ),
      ),
    );
  }
}
