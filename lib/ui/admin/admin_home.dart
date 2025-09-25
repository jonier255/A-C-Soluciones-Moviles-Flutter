import 'package:flutter/material.dart';

//este es el modelo solictud, por el momento lo hice aca para probar, 
// luego toca hacerla en la carpeta model
class Request {
  final String title;
  final String client;
  final String day;
  final String time;
  final String status; // Activo, Cancelado, Pendiente, etc.

  Request({
    required this.title,
    required this.client,
    required this.day,
    required this.time,
    required this.status,
  });
}

//pantalla principal
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de muestra para ver las solicitudes recientes y tener una idea de ui
    final requests = [
      Request(
        title: "Limpieza profunda de piscinas",
        client: "Roberto Castillo",
        day: "Miércoles",
        time: "7:40 a.m.",
        status: "Activo",
      ),
      Request(
        title: "Limpieza profunda de piscinas",
        client: "Roberto Castillo",
        day: "Jueves",
        time: "7:40 a.m.",
        status: "Cancelado",
      ),
      Request(
        title: "Limpieza profunda de piscinas",
        client: "Roberto Castillo",
        day: "Viernes",
        time: "7:40 a.m.",
        status: "Activo",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const _BottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeaderSection(),
              const SizedBox(height: 20),
              const _MainButtonsSection(),
              const SizedBox(height: 20),
              const _QuickAccessSection(),
              const SizedBox(height: 25),
              _RecentRequestsSection(requests: requests), // ahora es dinámico
            ],
          ),
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
    return Column(
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
    );
  }
}

//Botones de cliente y tecnico, los azules grandes
class _MainButtonsSection extends StatelessWidget {
  const _MainButtonsSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _MainButton(icon: Icons.badge, label: "Técnico"),
        _MainButton(icon: Icons.person, label: "Cliente"),
      ],
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
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
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

//botones chicos de servicios, visitas, admin y solitcitudes
class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection();

  @override
  Widget build(BuildContext context) {
  
    return Row(
      children: const [
        Expanded(
          child: _QuickButton(icon: Icons.build, label: "Servicios" ),
        ),
        SizedBox(width: 12), // Espacio entre botones
        Expanded(
          child: _QuickButton(icon: Icons.apartment, label: "Visitas"),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _QuickButton(icon: Icons.security, label: "Admin"),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _QuickButton(icon: Icons.mail, label: "Solicitudes",),
        ),
      ],
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
      // Padding vertical reducido para hacerlo menos alto.
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
          // Se usa Flexible para evitar que el texto se desborde en pantallas pequeñas.
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, // Corta el texto con "..." si no cabe
            ),
          ),
        ],
      ),
    );
    
  }
}

//solictudes recientes
class _RecentRequestsSection extends StatelessWidget {
  final List<Request> requests;

  const _RecentRequestsSection({required this.requests});

@override
Widget build(BuildContext context) {
  // seccion de solicitudes recientes
  return Padding(
    padding: const EdgeInsets.all(16), 
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Solicitudes recientes",
          style: TextStyle(
            fontSize: 25, 
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.5),
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        /// tarjeta que envuelve las solicitudes
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:  Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.9),
                spreadRadius: 4,
                blurRadius: 12,
                offset: const Offset(0, 3), // sombra interna
              ),
            ],
          ),
          child: Column(
            children: requests
                .map((req) => _RequestCard(request: req))
                .toList(),
          ),
        ),

        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: () {
              
            },
            child: Text("Ver más...", style: 
            TextStyle(fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black, 
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(1.0, 1.0),
              ),
            ],
            )
          ),
        ),
        ),  
      ],
    ),
  );
}
}


class _RequestCard extends StatelessWidget {
  final Request request;

  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    Color statusColor =
        request.status == "Activo" ? Colors.green : Colors.red;

    // le añadi la sombra de las tarjetas que son las tarjetas donde esat la informacion de las solicitudes
    return Card(
      
      color:Colors.white,
      
      // La propiedad 'elevation' controla la intensidad de la sombra.
      elevation: 8,
      // aca se añade el color de la sombra
      shadowColor: Colors.black.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      // Aumente el espacio entre ellas.
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.build, color: Colors.black),
        title: Text(request.title,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text("Cliente: ${request.client}\n${request.day} - Hora: ${request.time}"),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            request.status,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
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
      selectedItemColor: const Color.fromARGB(255, 46, 145, 216),
      unselectedItemColor: Colors.grey,
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
