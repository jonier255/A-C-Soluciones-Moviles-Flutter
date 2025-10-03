// custom_drawer.dart
import 'package:flutter/material.dart';

class DrawerClient extends StatelessWidget {
  const DrawerClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 46, 145, 216),
            ),
            accountName: Text(
              "Jonier Urrea", // 👤 Nombre quemado
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              "jonier.urrea@correounivalle.edu.co", // 📧 Email quemado
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
              Navigator.pop(context);
              // Aquí puedes navegar al dashboard
            },
          ),
          ListTile(
            leading: const Icon(Icons.miscellaneous_services),
            title: const Text('Servicios'),
            onTap: () {
              Navigator.pop(context);
              // Aquí puedes navegar al perfil
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page),
            title: const Text('Solicitudes'),
            onTap: () {
              Navigator.pop(context);
              // Aquí puedes navegar a pedidos
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial'),
            onTap: () {
              Navigator.pop(context);
              // Aquí puedes navegar a configuración
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            onTap: () {
              Navigator.pop(context);
              // Aquí puedes navegar a configuración
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context);
              // Aquí puedes agregar lógica de logout
            },
          ),
        ],
      ),
    );
  }
}
