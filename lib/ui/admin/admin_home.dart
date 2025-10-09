import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/visits/visits_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/service_api_visits.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request_screen.dart';
import 'package:flutter_a_c_soluciones/ui/admin/visits_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/request/request_bloc.dart';
import '../../bloc/request/request_event.dart';
import '../../bloc/request/request_state.dart';
import '../../model/request_model.dart';
import '../../repository/request_repository.dart';

// Pantalla principal del administrador
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos BlocProvider para crear y proveer el RequestBloc a esta pantalla.
    // También añadimos el evento FetchRequests para que los datos se carguen al entrar.
    return BlocProvider(
      create: (context) =>
          RequestBloc(RequestRepository())..add(FetchRequests()),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const _BottomNavBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderSection(),
                const SizedBox(height: 20),
                const _MainButtonsSection(),
                const SizedBox(height: 20),
                const _QuickAccessSection(),
                // La sección de solicitudes recientes ahora está integrada aquí
                const _RecentRequestsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Nueva sección que construye la lista de solicitudes recientes con el estilo proporcionado
class _RecentRequestsSection extends StatelessWidget {
  const _RecentRequestsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Título
          Text(
            "Solicitudes recientes",
            
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              
              shadows: [
                
                Shadow(
                  blurRadius: 4.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // BlocBuilder para construir la UI basada en el estado del BLoC
          BlocBuilder<RequestBloc, RequestState>(
            builder: (context, state) {
              if (state is RequestLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is RequestSuccess) {
                // Tomamos solo las primeras 3 solicitudes
                final recentRequests = state.requests.take(3).toList();
                if (recentRequests.isEmpty) {
                  return const Center(
                      child: Text("No hay solicitudes recientes."));
                }

                return Column(
                  children: [
                    // Contenedor con el estilo de sombra azul
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18.0),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.9),
                            spreadRadius: 4,
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      // Columna para las tarjetas de solicitud
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: recentRequests
                              .map((req) => _RequestCard(request: req))
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Botón "Ver más..."
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navega a la pantalla completa de solicitudes, reutilizando el BLoC actual.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<RequestBloc>(context),
                                child: RequestScreen(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Ver más...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is RequestError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text("Cargando solicitudes..."));
            },
          ),
        ],
      ),
    );
  }
}

// Widget para la tarjeta de una solicitud individual, restaurado a un Card con sombra
class _RequestCard extends StatelessWidget {
  final Request request;

  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    // Cada solicitud es una Card individual con su propia sombra y margen
    return Card(
      elevation: 8,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
        child: Row(
          children: [
            Card(
              margin: const EdgeInsets.all(0),
              elevation: 4,
              color: const Color(0xFFF0F2F5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                //icono de herramientas de services
                child: const Icon(Icons.build, color: Colors.black, size: 30),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.descripcion,
                            style: const TextStyle(fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            request.direccionServicio
                                .replaceAll('\n', ' ')
                                .replaceAll(RegExp(r'\s+'), ' '),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // NOTA: Mostrando ID del cliente. El backend debe ser modificado para enviar el nombre.
                          Text(
                            "Fecha de solictud: ${request.fechaSolicitud}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 8,
                      color: Color(0xFFF0F2F5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      margin: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          request.estado,
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//el header de la pantalla principal y la casilla de buscar
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              "assets/soluciones.png",
              height: 120,
            ),
          ),
          const SizedBox(height: 10),
          // Se refactorizaa el TextField en un Container para poder agregarle una sombra.
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4), // Posicion de la sombra
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar",
                prefixIcon: const Icon(Icons.search),
                // Se quita el borde del TextField para que no oculte la sombra del Container.
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Sin borde visible
                ),
                filled: true,
                fillColor: const Color(0xFFF0F2F5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Botones de cliente y tecnico, los azules grandes
class _MainButtonsSection extends StatelessWidget {
  const _MainButtonsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _MainButton(icon: Icons.badge, label: "Técnico"),
          _MainButton(icon: Icons.person, label: "Cliente"),
        ],
      ),
    );
  }
}

class _MainButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MainButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 90,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 17, 115, 196),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4), // posicion de la sombra
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

//botones de servicios, visitas, admin y solitcitudes
class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        
        children: [
          
          const Expanded(
            
            child: _QuickButton(icon: Icons.build, label: "Visitas"),
          ),
          const SizedBox(width: 12), // Espacio entre botones
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Al presionar "Visitas", vamos a la pantalla VisitsScreen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    
                    builder: (context) => BlocProvider(
                      create: (context) => VisitsBloc(VisitsRepository()),
                      child: VisitsScreen(),
                    ),
                  ),
                );
              },
              child: const _QuickButton(
                icon: Icons.visibility,
                label: "Visitas",
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: _QuickButton(icon: Icons.security, label: "Admin"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Al presionar "Solicitudes", vamos a la pantalla RequestScreen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Usamos BlocProvider para dirigirse el RequestBloc a la pantalla RequestScreen.
                    // Esto sirve para  podersolicitar los datos al backend.
                    builder: (context) => BlocProvider(
                      create: (context) => RequestBloc(RequestRepository()),
                      child: RequestScreen(),
                    ),
                  ),
                );
              },
              child: const _QuickButton(
                icon: Icons.mail,
                label: "Solicitudes",
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}


class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Se usa un Row para alinear el ícono y el texto horizontalmente.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Se centra el contenido
        children: [
          Icon(icon, color: Colors.black, size: 20),
          const SizedBox(width: 8),
          //flexible sirve para que las palabras no se salgan del contenedor
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              overflow:
                  TextOverflow.ellipsis, // Corta el texto con "..." si no cbe
            ),
          ),
        ],
      ),
    );
  }
}

//la seccion del menu de abajo
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => RequestBloc(RequestRepository()),
              child: RequestScreen(),
            ),
          ),
        );
      },
      selectedItemColor: const Color.fromARGB(255, 46, 145, 216),
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: 'Notificaciones'),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment), label: 'Solicitudes'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cuenta'),
      ],
    );
  }
}
