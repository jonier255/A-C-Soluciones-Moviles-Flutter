import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_state.dart';
import 'package:flutter_a_c_soluciones/ui/client/Drawer/drawerClient.dart';
import 'package:flutter_a_c_soluciones/ui/client/Header/client_header.dart';
import 'package:flutter_a_c_soluciones/ui/client/Home/homeClient.dart';
import 'package:flutter_a_c_soluciones/ui/client/services/services_page.dart';
import 'package:flutter_a_c_soluciones/ui/client/Requests/requests_page.dart';
import 'package:flutter_a_c_soluciones/ui/client/Chat/chat_page.dart';
import '../../../../repository/secure_storage_service.dart';
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

  void _navigateTo(String route) {
    setState(() {
      _currentRoute = route;
    });
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    }
  }

  Future<int> _getClienteId() async {
    final storage = SecureStorageService();
    final idStr = await storage.getUserData('cliente_id');
    return int.tryParse(idStr ?? '0') ?? 0;
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
          if (currentUserName != null) userName = currentUserName;
          final currentUserEmail = loginBloc.currentUserEmail;
          if (currentUserEmail != null) userEmail = currentUserEmail;
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
                  child: FutureBuilder<int>(
                    future: _getClienteId(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final clienteId = snapshot.data!;

                      final routes = {
                        '/client_home': const ClientHomeContent(),
                        '/client_services':
                            ServicesContent(clienteId: clienteId),
                        '/client_requests': const RequestsContent(),
                        '/client_chat': const ChatContent(),
                      };

                      return routes[_currentRoute] ?? const ClientHomeContent();
                    },
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
