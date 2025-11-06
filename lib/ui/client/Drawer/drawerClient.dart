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
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 46, 145, 216),
            ),
            accountName: Text(
              userName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              userEmail,
              style: const TextStyle(fontSize: 14),
            ),
            currentAccountPicture: const CircleAvatar(
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
            onTap: () => onItemSelected('/client_home'),
          ),
          ListTile(
            leading: const Icon(Icons.miscellaneous_services),
            title: const Text('Servicios'),
            onTap: () => onItemSelected('/client_services'),
          ),
          ListTile(
            leading: const Icon(Icons.request_page),
            title: const Text('Solicitudes'),
            onTap: () => onItemSelected('/client_requests'),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            onTap: () => onItemSelected('/client_chat'),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
