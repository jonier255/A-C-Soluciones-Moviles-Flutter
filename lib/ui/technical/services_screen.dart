import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/service/service_bloc.dart';
import '../../bloc/service/service_event.dart';
import '../../bloc/service/service_state.dart';
import '../../model/servicio_model.dart';
import '../../repository/service_repository.dart';

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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.nombre,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(service.descripcion),
            const SizedBox(height: 8),
            Text('Estado: ${service.estado}'),
          ],
        ),
      ),
    );
  }
}
