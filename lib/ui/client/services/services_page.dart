// import 'package:flutter_a_c_soluciones/ui/client/Drawer/drawerClient.dart';
// import 'package:flutter_a_c_soluciones/ui/client/lib/client_header.dart';

// import 'package:flutter/material.dart';

// class ServicesPage extends StatelessWidget {
//   const ServicesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const DrawerClient(),
//       body: const Column(
//         children: [
//           ClientHeader(
//             name: "Usuario",
//             activity: "0%",
//           ), // ✅ Solo lo llamas así
//           Expanded(
//             child: Center(
//               child: Text("🧰 Servicios disponibles"),
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
            name: "Usuario",
            activity: "0%",
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

                return ListView.builder(
                  itemCount: services.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.build_circle_rounded,
                            color: Color.fromARGB(255, 46, 145, 216), size: 40),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
