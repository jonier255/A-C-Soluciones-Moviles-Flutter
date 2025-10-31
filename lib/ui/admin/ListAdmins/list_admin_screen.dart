import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/listAdmins/admins_event.dart';
import '../../../../bloc/listAdmins/admins_state.dart';
import '../../../../bloc/listAdmins/admins_bloc.dart';
import '../../../../ui/admin/Home/admin_home.dart';
import '../../../../ui/admin/request/request_screen.dart';
import '../../../../bloc/request/request_bloc.dart';
import '../../../../repository/services_admin/request_repository.dart';

class AdminsScreen extends StatefulWidget {
  @override
  _AdminsScreenState createState() => _AdminsScreenState();
}

class _AdminsScreenState extends State<AdminsScreen> {
  int _currentPage = 1;
  final int _adminsPerPage = 4;

  @override
  void initState() {
    super.initState();
    context.read<AdminsBloc>().add(FetchAdmins());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const _BottomNavBar(),
      body: Stack(
        children: [
          // Curva azul superior
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 180,
              color: const Color.fromARGB(255, 46, 145, 216),
            ),
          ),

          // Botón de retroceso y título
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Center(
                  child: Text(
                    'Lista de Administradores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal
          Padding(
            padding: const EdgeInsets.only(top: 180.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<AdminsBloc, AdminsState>(
                    builder: (context, state) {
                      if (state is AdminsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AdminsSuccess) {
                        final totalPages = state.admins.isNotEmpty
                            ? (state.admins.length / _adminsPerPage).ceil()
                            : 1;

                        final safePage = _currentPage.clamp(1, totalPages);
                        final startIndex = (safePage - 1) * _adminsPerPage;
                        final endIndex =
                            (safePage * _adminsPerPage).clamp(0, state.admins.length);
                        final currentAdmins = state.admins.isNotEmpty
                            ? state.admins.sublist(startIndex, endIndex)
                            : [];

                        return Column(
                          children: [
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 35.0, vertical: 20),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 55, 214, 23).withOpacity(0.9),
                                      spreadRadius: 4,
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: currentAdmins.isNotEmpty
                                    ? ListView.builder(
                                        padding: const EdgeInsets.all(12),
                                        itemCount: currentAdmins.length,
                                        itemBuilder: (context, index) {
                                          final admin = currentAdmins[index];
                                          return Center(
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 4,
                                              margin: const EdgeInsets.symmetric(
                                                  vertical: 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(12),
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset:
                                                                const Offset(0, 3),
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.person,
                                                        size: 28,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Nombre: ",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                color: Colors.black,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      "${admin.nombre} ${admin.apellido}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Cédula: ",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                color: Colors.black,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: admin
                                                                      .numeroCedula,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Correo: ",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                color: Colors.black,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: admin
                                                                      .correoElectronico,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Text(
                                          "No hay administradores registrados",
                                        ),
                                      ),
                              ),
                            ),

                            // Paginación
                            if (state.admins.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (safePage > 1)
                                      _buildArrowButton("<", () {
                                        setState(() {
                                          _currentPage = safePage - 1;
                                        });
                                      }),
                                    ...List.generate(totalPages, (index) {
                                      final pageNumber = index + 1;
                                      return _buildPageButton(
                                        pageNumber.toString(),
                                        pageNumber == safePage,
                                        () {
                                          setState(() {
                                            _currentPage = pageNumber;
                                          });
                                        },
                                      );
                                    }),
                                    if (safePage < totalPages)
                                      _buildArrowButton(">", () {
                                        setState(() {
                                          _currentPage = safePage + 1;
                                        });
                                      }),
                                  ],
                                ),
                              ),
                          ],
                        );
                      } else if (state is AdminsError) {
                        return Center(child: Text(state.message));
                      } else {
                        return const Center(
                            child: Text("No hay administradores"));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Botones de paginación
  Widget _buildPageButton(String text, bool selected, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(3),
          backgroundColor:
              selected ? const Color.fromARGB(255, 156, 204, 243) : Colors.white,
          foregroundColor: selected ? Colors.white : Colors.blue,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  Widget _buildArrowButton(String text, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// Menú inferior
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => RequestBloc(RequestRepository()),
                child: RequestScreen(),
              ),
            ),
          );
        }
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

// Curva superior azul
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
