import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/service/service_bloc.dart';
import '../../bloc/service/service_event.dart';
import '../../bloc/service/service_state.dart';
import '../../model/servicio_model.dart';
import '../../repository/service_repository.dart';
import 'service_details_screen.dart';
import 'package:flutter_a_c_soluciones/ui/technical/widgets/bottom_nav_bar.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc(ServiceRepository())..add(FetchServices()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Servicios'),
        ),
        bottomNavigationBar: const BottomNavBar(),
        body: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ServiceSuccess) {
              if (state.services.isEmpty) {
                return const Center(child: Text("No hay servicios disponibles."));
              }
              return ListView.builder(
                itemCount: state.services.length,
                itemBuilder: (context, index) {
                  return _ServiceCard(service: state.services[index]);
                },
              );
            }
            if (state is ServiceError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Cargando servicios..."));
          },
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Servicio service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(service: service),
          ),
        );
      },
      child: Card(
        elevation: 6,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              const Icon(Icons.miscellaneous_services, size: 35, color: Colors.black),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.nombre,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      service.descripcion.length > 50
                          ? '${service.descripcion.substring(0, 50)}...'
                          : service.descripcion,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: service.estado == "activo"
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  service.estado,
                  style: TextStyle(
                    color: service.estado == "activo"
                        ? Colors.green[800]
                        : Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
