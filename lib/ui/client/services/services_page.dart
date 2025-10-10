// import 'package:flutter/material.dart';
// import 'package:flutter_a_c_soluciones/ui/client/Drawer/drawerClient.dart';
// import 'package:flutter_a_c_soluciones/ui/client/lib/client_header.dart';
// import 'package:flutter_a_c_soluciones/repository/client/service_api_service.dart';
// import 'package:flutter_a_c_soluciones/model/client/service_model.dart';

// class ServicesPage extends StatefulWidget {
//   const ServicesPage({super.key});

//   @override
//   State<ServicesPage> createState() => _ServicesPageState();
// }

// class _ServicesPageState extends State<ServicesPage> {
//   final ServiceRepository _repository = ServiceRepository();
//   late Future<List<ServiceModel>> _futureServices;

//   // 🔹 Control de paginación
//   int _currentPage = 0;
//   static const int _itemsPerPage = 4;

//   @override
//   void initState() {
//     super.initState();
//     _futureServices = _repository.getServices();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const DrawerClient(),
//       body: Column(
//         children: [
//           const ClientHeader(
//             name: "Usuario",
//             activity: "0%",
//           ),
//           Expanded(
//             child: FutureBuilder<List<ServiceModel>>(
//               future: _futureServices,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       "❌ Error: ${snapshot.error}",
//                       style: const TextStyle(color: Colors.red),
//                       textAlign: TextAlign.center,
//                     ),
//                   );
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(
//                     child: Text("No hay servicios disponibles"),
//                   );
//                 }

//                 final services = snapshot.data!;
//                 final totalPages = (services.length / _itemsPerPage).ceil();

//                 // 🔹 Calcular el rango de servicios a mostrar
//                 final startIndex = _currentPage * _itemsPerPage;
//                 final endIndex = (_currentPage + 1) * _itemsPerPage;
//                 final currentServices = services.sublist(startIndex,
//                     endIndex > services.length ? services.length : endIndex);

//                 return LayoutBuilder(
//                   builder: (context, constraints) {
//                     return ConstrainedBox(
//                       constraints: BoxConstraints(
//                         minHeight: constraints.maxHeight,
//                       ),
//                       child: Column(
//                         mainAxisAlignment:
//                             MainAxisAlignment.center, // 🔹 Centra verticalmente
//                         children: [
//                           Expanded(
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: ListView.builder(
//                                 shrinkWrap:
//                                     true, // 🔹 Ajusta la altura exacta del contenido
//                                 itemCount: currentServices.length,
//                                 padding: const EdgeInsets.all(12),
//                                 itemBuilder: (context, index) {
//                                   final service = currentServices[index];
//                                   return Card(
//                                     margin:
//                                         const EdgeInsets.symmetric(vertical: 8),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     elevation: 4,
//                                     child: ListTile(
//                                       leading: const Icon(
//                                         Icons.build_circle_rounded,
//                                         color:
//                                             Color.fromARGB(255, 46, 145, 216),
//                                         size: 40,
//                                       ),
//                                       title: Text(
//                                         service.nombre,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                       subtitle: Text(
//                                         service.descripcion,
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       trailing: Text(
//                                         "\$${service.price}",
//                                         style: const TextStyle(
//                                           color: Colors.green,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),

//                           // 🔹 Controles de paginación centrados al fondo
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(Icons.arrow_back_ios),
//                                   onPressed: _currentPage > 0
//                                       ? () {
//                                           setState(() {
//                                             _currentPage--;
//                                           });
//                                         }
//                                       : null,
//                                 ),
//                                 Text(
//                                   "Página ${_currentPage + 1} de $totalPages",
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.arrow_forward_ios),
//                                   onPressed: _currentPage < totalPages - 1
//                                       ? () {
//                                           setState(() {
//                                             _currentPage++;
//                                           });
//                                         }
//                                       : null,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/client/Drawer/drawerClient.dart';
import 'package:flutter_a_c_soluciones/ui/client/lib/client_header.dart';
import 'package:flutter_a_c_soluciones/repository/client/service_api_service.dart';
import 'package:flutter_a_c_soluciones/model/client/service_model.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final ServiceRepository _repository = ServiceRepository();
  late Future<List<ServiceModel>> _futureServices;

  // 🔹 Control de paginación
  int _currentPage = 0;
  static const int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _futureServices = _repository.getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerClient(),
      body: Column(
        children: [
          const ClientHeader(
            name: "Jonier Urrea",
            activity: "70%",
          ),

          // 🔹 Título principal
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "Servicios",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E91D8), // azul claro
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: FutureBuilder<List<ServiceModel>>(
              future: _futureServices,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "❌ Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No hay servicios disponibles"),
                  );
                }

                final services = snapshot.data!;
                final totalPages = (services.length / _itemsPerPage).ceil();

                // 🔹 Calcular el rango de servicios a mostrar
                final startIndex = _currentPage * _itemsPerPage;
                final endIndex = (_currentPage + 1) * _itemsPerPage;
                final currentServices = services.sublist(
                  startIndex,
                  endIndex > services.length ? services.length : endIndex,
                );

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        children: [
                          // 🔹 Lista de servicios
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: currentServices.length,
                                padding: const EdgeInsets.all(12),
                                itemBuilder: (context, index) {
                                  final service = currentServices[index];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.build_circle_rounded,
                                        color:
                                            Color.fromARGB(255, 46, 145, 216),
                                        size: 40,
                                      ),
                                      title: Text(
                                        service.nombre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Text(
                                        service.descripcion,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Text(
                                        "\$${service.price}",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // 🔹 Controles de paginación
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios),
                                  onPressed: _currentPage > 0
                                      ? () {
                                          setState(() {
                                            _currentPage--;
                                          });
                                        }
                                      : null,
                                ),
                                Text(
                                  "Página ${_currentPage + 1} de $totalPages",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: _currentPage < totalPages - 1
                                      ? () {
                                          setState(() {
                                            _currentPage++;
                                          });
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
