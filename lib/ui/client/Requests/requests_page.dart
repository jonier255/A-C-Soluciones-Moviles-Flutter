// // requests_page.dart
// import 'package:flutter/material.dart';

// class RequestsPage extends StatelessWidget {
//   const RequestsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: Text("📄 Solicitudes del cliente")),
//     );
//   }
// }
import 'package:flutter_a_c_soluciones/ui/client/Drawer/drawerClient.dart';
import 'package:flutter_a_c_soluciones/ui/client/lib/client_header.dart';

import 'package:flutter/material.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerClient(),
      body: const Column(
        children: [
          ClientHeader(
            name: "Usuario",
            activity: "0%",
          ), // ✅ Solo lo llamas así
          Expanded(
            child: Center(
              child: Text("📄 Solicitudes del cliente"),
            ),
          ),
        ],
      ),
    );
  }
}
