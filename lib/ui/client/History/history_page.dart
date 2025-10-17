import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/login/login_bloc.dart';
import 'package:flutter_a_c_soluciones/ui/client/Drawer/drawerClient.dart';
import 'package:flutter_a_c_soluciones/ui/client/lib/client_header.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerClient(),
      body: SafeArea(
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            String name = "Jonier Urrea";
            String activity = "70%";
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClientHeader(
                    name: name,
                    activity: activity,
                    onEdit: () {
                      // Acción al presionar editar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Editar perfil en desarrollo 🚧'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      "📜 Historial de servicios",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Ejemplo de historial (puedes reemplazar con datos reales)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.build,
                            color: Color.fromARGB(255, 46, 145, 216)),
                        title: Text('Servicio #${index + 1}'),
                        subtitle: const Text('Finalizado correctamente'),
                        trailing:
                            const Icon(Icons.check_circle, color: Colors.green),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
