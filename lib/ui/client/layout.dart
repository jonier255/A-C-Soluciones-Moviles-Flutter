import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_state.dart';
import 'package:flutter_a_c_soluciones/ui/client/Drawer/drawerClient.dart';
import 'package:flutter_a_c_soluciones/ui/client/Header/client_header.dart';

import 'package:flutter_a_c_soluciones/ui/client/Home/homeClient.dart';
import 'package:flutter_a_c_soluciones/ui/client/services/services_page.dart';
import 'package:flutter_a_c_soluciones/ui/client/Requests/requests_page.dart';
import 'package:flutter_a_c_soluciones/ui/client/History/history_page.dart';
import 'package:flutter_a_c_soluciones/ui/client/Chat/chat_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_bloc.dart';

class ClientLayout extends StatefulWidget {
  const ClientLayout({super.key});

  @override
  State<ClientLayout> createState() => _ClientLayoutState();
}

class _ClientLayoutState extends State<ClientLayout> {
  String _currentRoute = '/client_home';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Map<String, Widget> _routes = {
    '/client_home': const ClientHomeContent(),
    '/client_services': const ServicesContent(),
    '/client_requests': const RequestsContent(),
    '/client_history': const HistoryContent(),
    '/client_chat': const ChatContent(),
  };

  void _navigateTo(String route) {
    setState(() {
      _currentRoute = route;
    });
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        String userName = "Usuario";
        String userEmail = "correo@ejemplo.com";
        String userActivity = "70%";

        if (state is LoginSuccess) {
          userName = state.nombre;
          userEmail = state.correoElectronico;
        } else {
          final loginBloc = context.read<LoginBloc>();
          final currentUserName = loginBloc.currentUserName;
          if (currentUserName != null) {
            userName = currentUserName;
          }
          final currentUserEmail = loginBloc.currentUserEmail;
          if (currentUserEmail != null) {
            userEmail = currentUserEmail;
          }
        }

        return Scaffold(
          key: _scaffoldKey,
          drawer: DrawerClient(
            onItemSelected: _navigateTo,
            userName: userName,
            userEmail: userEmail,
          ),
          body: SafeArea(
            child: Column(
              children: [
                ClientHeader(
                  name: userName,
                  activity: userActivity,
                  onMenuPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: _routes[_currentRoute] ?? const ClientHomeContent(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
