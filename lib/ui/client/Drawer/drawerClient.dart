import 'package:flutter/material.dart';
import '../../../../repository/secure_storage_service.dart';
import '../../login.dart';

class DrawerClient extends StatelessWidget {
  final Function(String) onItemSelected;
  final String userName;
  final String userEmail;

  const DrawerClient({
    super.key,
    required this.onItemSelected,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isTablet = screenWidth > 600;

    return Drawer(
      width: isTablet ? screenWidth * 0.35 : screenWidth * 0.75,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header con gradiente - ocupa todo el ancho
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isTablet ? 32 : 24,
              horizontal: isTablet ? 24 : 16,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2E91D8),
                  Color(0xFF56AFEC),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: Color(0xFF2E91D8),
                    ),
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: Icons.person_rounded,
                  title: 'Mi Perfil',
                  route: '/client_profile',
                  isTablet: isTablet,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.home_rounded,
                  title: 'Inicio',
                  route: '/client_home',
                  isTablet: isTablet,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.miscellaneous_services_rounded,
                  title: 'Servicios',
                  route: '/client_services',
                  isTablet: isTablet,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.request_page_rounded,
                  title: 'Solicitudes',
                  route: '/client_requests',
                  isTablet: isTablet,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.chat_bubble_rounded,
                  title: 'Chat',
                  route: '/client_chat',
                  isTablet: isTablet,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: _buildDrawerItem(
              context: context,
              icon: Icons.logout_rounded,
              title: 'Cerrar Sesión',
              route: '',
              isTablet: isTablet,
              isLogout: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isTablet,
    bool isLogout = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 12 : 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isLogout ? Colors.red.shade50 : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : const Color(0xFF2E91D8),
          size: isTablet ? 28 : 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () async {
          if (isLogout) {
            // Mostrar diálogo de confirmación primero
            final confirmLogout = await showDialog<bool>(
              context: context,
              builder: (BuildContext dialogContext) {
                final mediaQuery = MediaQuery.of(dialogContext);
                final isTablet = mediaQuery.size.width > 600;

                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                        size: isTablet ? 28 : 24,
                      ),
                      SizedBox(width: isTablet ? 12 : 8),
                      Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    '¿Estás seguro de que deseas cerrar sesión?',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(false);
                      },
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );

            // Si el usuario confirmó, proceder con el logout
            if (confirmLogout == true) {
              // Cerrar el drawer primero
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Scaffold.of(context).closeDrawer();
              }

              // Esperar un momento para que el drawer se cierre
              await Future.delayed(const Duration(milliseconds: 100));

              // Limpiar todos los datos almacenados
              final secureStorage = SecureStorageService();
              await secureStorage.clearAll();

              // Navegar al login y eliminar todas las rutas anteriores
              // Usar rootNavigator para asegurar que navegamos desde el Navigator raíz
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false,
                );
              }
            } else {
              // Si canceló, solo cerrar el drawer
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Scaffold.of(context).closeDrawer();
              }
            }
          } else if (route.isNotEmpty) {
            // Para la ruta de perfil, no cerrar el drawer aquí, se maneja en _navigateTo
            if (route == '/client_profile') {
              onItemSelected(route);
            } else {
              onItemSelected(route);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Scaffold.of(context).closeDrawer();
              }
            }
          }
        },
      ),
    );
  }
}
