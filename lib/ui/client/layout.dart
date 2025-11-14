import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_state.dart';
import 'package:flutter_a_c_soluciones/ui/client/Drawer/drawerClient.dart';
import 'package:flutter_a_c_soluciones/ui/client/Header/client_header.dart';
import 'package:flutter_a_c_soluciones/ui/client/Home/homeClient.dart';
import 'package:flutter_a_c_soluciones/ui/client/services/services_page.dart';
import 'package:flutter_a_c_soluciones/ui/client/Requests/requests_page.dart';
import 'package:flutter_a_c_soluciones/ui/client/Chat/chat_page.dart';
import 'package:flutter_a_c_soluciones/ui/client/profile/edit_profile_client.dart';
import '../../../../repository/secure_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/client/edit_profile_client_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/client/client_profile_repository.dart';

class ClientLayout extends StatefulWidget {
  const ClientLayout({super.key});

  @override
  State<ClientLayout> createState() => _ClientLayoutState();
}

class _ClientLayoutState extends State<ClientLayout> {
  String _currentRoute = '/client_home';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? _clienteId;
  bool _isLoadingClienteId = true;
  String _userName = "Usuario";
  String _userEmail = "correo@ejemplo.com";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = SecureStorageService();
    final idStr = await storage.getUserData('cliente_id');
    final userName = await storage.getUserData('user_name');
    final userEmail = await storage.getUserData('user_email');
    
    setState(() {
      _clienteId = int.tryParse(idStr ?? '0') ?? 0;
      if (userName != null && userName.isNotEmpty) {
        _userName = userName;
      }
      if (userEmail != null && userEmail.isNotEmpty) {
        _userEmail = userEmail;
      }
      _isLoadingClienteId = false;
    });
  }

  void _navigateTo(String route) {
    // Si es la ruta de perfil, navegar a la página de editar perfil
    if (route == '/client_profile') {
      // Cerrar el drawer primero
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.closeDrawer();
      }
      // Esperar un momento para que el drawer se cierre antes de navegar
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => EditProfileClientBloc(
                  clientProfileRepository: ClientProfileRepository(),
                ),
                child: const EditProfileClientScreen(),
              ),
            ),
          ).then((result) {
            // Si se actualizó el perfil, recargar los datos del usuario
            if (result == true) {
              _loadUserData();
            }
          });
        }
      });
      return;
    }
    
    setState(() {
      _currentRoute = route;
    });
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1024;

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        String userName = _userName;
        String userEmail = _userEmail;
        String userActivity = "70%";

        // Priorizar datos del estado del bloc si están disponibles
        if (state is LoginSuccess) {
          if (state.nombre.isNotEmpty) {
            userName = state.nombre;
          }
          if (state.correoElectronico.isNotEmpty) {
            userEmail = state.correoElectronico;
          }
        } else {
          final loginBloc = context.read<LoginBloc>();
          final currentUserName = loginBloc.currentUserName;
          if (currentUserName != null && currentUserName.isNotEmpty) {
            userName = currentUserName;
          }
          final currentUserEmail = loginBloc.currentUserEmail;
          if (currentUserEmail != null && currentUserEmail.isNotEmpty) {
            userEmail = currentUserEmail;
          }
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF5F7FA),
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
                    constraints: isDesktop && screenWidth > 1200
                        ? BoxConstraints(maxWidth: 1200)
                        : null,
                    margin: isDesktop && screenWidth > 1200
                        ? EdgeInsets.symmetric(
                            horizontal: (screenWidth - 1200) / 2)
                        : null,
                    child: _isLoadingClienteId
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2E91D8),
                              ),
                            ),
                          )
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: _buildCurrentRoute(),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentRoute() {
    final routes = {
      '/client_home': const ClientHomeContent(key: ValueKey('/client_home')),
      '/client_services': ServicesContent(
        key: const ValueKey('/client_services'),
        clienteId: _clienteId ?? 0,
      ),
      '/client_requests': const RequestsContent(key: ValueKey('/client_requests')),
      '/client_chat': const ChatContent(key: ValueKey('/client_chat')),
    };

    return routes[_currentRoute] ??
        const ClientHomeContent(key: ValueKey('/client_home'));
  }
}
