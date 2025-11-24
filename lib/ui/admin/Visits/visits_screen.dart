import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/admin/Home/admin_home.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request/request_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/visits/visits_bloc.dart';
import '../../../bloc/visits/visits_event.dart';
import '../../../bloc/visits/visits_state.dart';
import '../../../repository/services_admin/request_repository.dart';

class VisitsScreen extends StatefulWidget {
  const VisitsScreen({super.key});

  @override
  _VisitsScreenState createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  int _currentPage = 1; // página actual
  final int _visitsPerPage = 4; // cantidad de cards por página

  @override
  void initState() {
    super.initState();
    context.read<VisitsBloc>().add(FetchVisits());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    // responsive values
    final topCurveHeight = height * 0.225; // ~180
    final titleTop = height * 0.05; // ~40
    final titleSidePadding = width * 0.025; // ~10
    final titleFontSize = width * 0.06; // ~24
    final smallGap = height * 0.02; // ~16
    final containerMarginHorizontal = width * 0.09; // ~35
    final containerMarginVertical = height * 0.025; // ~20
    final containerInnerPadding = width * 0.02; // ~8
    final listPadding = width * 0.03; // ~12
    final cardPadding = width * 0.04; // ~16
    final cardMarginVertical = height * 0.012; // ~10
    final iconCircleSize = width * 0.07; // ~28

    return Scaffold(
      bottomNavigationBar: const _BottomNavBar(),
      body: Stack(
        children: [
          // Curva azul superior
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: topCurveHeight,
              color: const Color.fromARGB(255, 46, 145, 216),
            ),
          ),
          // Botón de retroceso y título
          Positioned(
            top: titleTop,
            left: titleSidePadding,
            right: titleSidePadding,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: width * 0.075),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Center(
                  child: Text(
                    'Lista de Visitas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contenido principal
          Padding(
            padding: EdgeInsets.only(top: topCurveHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: smallGap),
                // Contenido principal
                Expanded(
                  child: BlocBuilder<VisitsBloc, VisitsState>(
                    builder: (context, state) {
                      if (state is VisitsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is VisitsSuccess) {
                        final totalPages = state.visits.isNotEmpty
                            ? (state.visits.length / _visitsPerPage).ceil()
                            : 1;

                        final safePage = _currentPage.clamp(1, totalPages);

                        // calcular rango de visitas a mostrar
                        final startIndex = (safePage - 1) * _visitsPerPage;
                        final endIndex = (safePage * _visitsPerPage)
                            .clamp(0, state.visits.length);

                        final currentVisits = state.visits.isNotEmpty
                            ? state.visits.sublist(startIndex, endIndex)
                            : [];

                        return Column(
                          children: [
                            // ontainer visitas
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: containerMarginHorizontal,
                                    vertical: containerMarginVertical),
                                padding: EdgeInsets.symmetric(
                                    horizontal: containerInnerPadding,
                                    vertical: containerInnerPadding),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withValues(alpha: 0.9),
                                      spreadRadius: 4,
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: currentVisits.isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.all(listPadding),
                                        itemCount: currentVisits.length,
                                        itemBuilder: (context, index) {
                                          final visit = currentVisits[index];
                                          return Center(
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 4,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: cardMarginVertical),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(cardPadding),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(iconCircleSize * 0.35),
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withValues(
                                                                    alpha: 0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                          Icons.article,
                                                          size: iconCircleSize),
                                                    ),
                                                    SizedBox(width: width * 0.04),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  "Notas previas: ",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: visit
                                                                          .notasPrevias ??
                                                                      "",
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
                                                          SizedBox(
                                                              height: height * 0.005),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  "Notas posteriores: ",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: visit
                                                                          .notasPosteriores ??
                                                                      "",
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
                                                          SizedBox(
                                                              height: height * 0.005),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Fecha: ",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: visit.fechaProgramada !=
                                                                          null
                                                                      ? visit
                                                                          .fechaProgramada
                                                                          .toIso8601String()
                                                                          .split(
                                                                              "T")
                                                                          .first
                                                                      : "Sin fecha",
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
                                        child:
                                            Text("No hay visitas registradas")),
                              ),
                            ),

                            // Paginacion afuera del container — usar Wrap para evitar overflow
                            if (state.visits.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 8,
                                  runSpacing: 8,
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
                      } else if (state is VisitsError) {
                        return Center(child: Text(state.message));
                      } else {
                        return const Center(child: Text("No hay visitas"));
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

  // Boton de paginacion 
  Widget _buildPageButton(String text, bool selected, VoidCallback onPressed) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    return Container(
      padding: EdgeInsets.all(w * 0.005),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.all(w * 0.007),
          backgroundColor: selected
              ? const Color.fromARGB(255, 156, 204, 243)
              : Colors.white,
          foregroundColor: selected ? Colors.white : Colors.blue,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  // Boton de paginacion (flechas)
  Widget _buildArrowButton(String text, VoidCallback onPressed) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.01),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.all(w * 0.03),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// Menu bajo
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
                child: const RequestScreen(),
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

/// curva de arriba
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
