// import 'package:flutter/material.dart';
// import '../Drawer/drawerClient.dart';
// import 'package:flutter_a_c_soluciones/ui/client/lib/client_header.dart';

// class ClientScreen extends StatelessWidget {
//   const ClientScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const DrawerClient(),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔹 Aquí llamas directamente tu widget reutilizable
//               const ClientHeader(
//                 name: "Jonier Urrea",
//                 activity: "70%",
//               ),

//               const SizedBox(height: 10),

//               // Branding
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Center(
//                   child: Image.asset(
//                     "assets/soluciones.png",
//                     height: 250,
//                     width: 250,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 250,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     _buildImageCard("assets/servicio1.jpg", "Servicio 1"),
//                     _buildImageCard("assets/servicio2.jpg", "Servicio 2"),
//                     _buildImageCard("assets/servicio3.webp", "Servicio 3"),
//                     _buildImageCard("assets/servicio4.jpg", "Servicio 4"),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImageCard(String imagePath, String title) {
//     return Container(
//       width: 150,
//       margin: const EdgeInsets.only(left: 16, right: 8),
//       child: Card(
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         elevation: 3,
//         child: Column(
//           children: [
//             Expanded(
//               child: Image.asset(
//                 imagePath,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../Drawer/drawerClient.dart';
import 'package:flutter_a_c_soluciones/ui/client/lib/client_header.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerClient(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Encabezado del cliente
              const ClientHeader(
                name: "Jonier Urrea",
                activity: "70%",
              ),

              const SizedBox(height: 10),

              // 🔹 Logo central
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Image.asset(
                    "assets/soluciones.png",
                    height: 220,
                    width: 220,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Cards horizontales de servicios
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildServiceCard("assets/servicio1.jpg", "Instalaciones"),
                    _buildServiceCard("assets/servicio2.jpg", "Mantenimiento"),
                    _buildServiceCard("assets/servicio3.webp", "Reparaciones"),
                    _buildServiceCard("assets/servicio4.jpg", "Consultoría"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(String imagePath, String title) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(left: 16, right: 8),
      child: InkWell(
        onTap: () {}, // puedes agregar acción
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade50,
                Colors.blue.shade100.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.antiAlias,
            color: Colors.white.withOpacity(0.9),
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.lightBlueAccent.withOpacity(0.6),
                        Colors.blueAccent.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
