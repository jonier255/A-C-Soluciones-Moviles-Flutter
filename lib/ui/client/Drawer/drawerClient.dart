import 'package:flutter/material.dart';

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
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 46, 145, 216),
            ),
            accountName: Text(
              userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              userEmail,
              style: TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: Color.fromARGB(255, 46, 145, 216),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              onItemSelected('/client_home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.miscellaneous_services),
            title: const Text('Servicios'),
            onTap: () {
              onItemSelected('/client_services');
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page),
            title: const Text('Solicitudes'),
            onTap: () {
              onItemSelected('/client_requests');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial'),
            onTap: () {
              onItemSelected('/client_history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            onTap: () {
              onItemSelected('/client_chat');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context);
              // Implement logout
            },
          ),
        ],
      ),
    );
  }
}
