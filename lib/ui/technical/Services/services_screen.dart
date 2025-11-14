import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/service/service_bloc.dart';
import '../../../bloc/service/service_event.dart';
import '../../../bloc/service/service_state.dart';
import '../../../model/servicio_model.dart';
import '../../../repository/service_repository.dart';
import 'service_details_screen.dart';
import 'package:flutter_a_c_soluciones/ui/technical/widgets/bottom_nav_bar.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc(repository: ServiceRepository())..add(LoadServices()),
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
            if (state is ServiceFailure) {
              return Center(child: Text(state.error));
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.04),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.05)),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.035),
          child: Row(
            children: [
              Icon(Icons.miscellaneous_services, size: screenWidth * 0.09, color: Colors.black),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.nombre,
                        style: TextStyle(
                            fontSize: screenWidth * 0.038, fontWeight: FontWeight.bold)),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      service.descripcion.length > 50
                          ? '${service.descripcion.substring(0, 50)}...'
                          : service.descripcion,
                      style: TextStyle(fontSize: screenWidth * 0.032, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenHeight * 0.008),
                decoration: BoxDecoration(
                  color: service.estado == "activo"
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
                child: Text(
                  service.estado,
                  style: TextStyle(
                    color: service.estado == "activo"
                        ? Colors.green[800]
                        : Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.03,
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
