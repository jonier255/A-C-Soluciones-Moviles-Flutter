import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_event.dart';
import '../../../bloc/request/request_state.dart';
import '../../admin/Home/admin_home.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  int _currentPage = 1;
  final int _requestsPerPage = 4;

  @override
  void initState() {
    super.initState();
    context.read<RequestBloc>().add(FetchRequests());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final topCurveHeight = height * 0.225; 
    final titleTop = height * 0.05; 
    final titleSidePadding = width * 0.025; 
    final titleFontSize = width * 0.06; 
    final smallGap = height * 0.02; 
    final containerMarginHorizontal = width * 0.09; 
    final containerMarginVertical = height * 0.025; 
    final containerInnerPadding = width * 0.02; 
    final listPadding = width * 0.03; 
    final cardPadding = width * 0.04;
    final cardMarginVertical = height * 0.012; 
    final iconCircleSize = width * 0.07;
    

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
                    'Lista de Solicitudes',
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
                Expanded(
                  child: BlocBuilder<RequestBloc, RequestState>(
                    builder: (context, state) {
                      if (state is RequestLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is RequestLoaded) {
                        final totalPages = state.requests.isNotEmpty
                            ? (state.requests.length / _requestsPerPage).ceil()
                            : 1;

                        final safePage = _currentPage.clamp(1, totalPages);
                        final startIndex = (safePage - 1) * _requestsPerPage;
                        final endIndex =
                            (safePage * _requestsPerPage).clamp(0, state.requests.length);
                        final currentRequests = state.requests.isNotEmpty
                            ? state.requests.sublist(startIndex, endIndex)
                            : [];

                        return Column(
                          children: [
                            // Contenedor con las solicitudes
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
                                      color: const Color.fromARGB(255, 179, 46, 241)
                                          .withOpacity(0.9),
                                      spreadRadius: 4,
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: currentRequests.isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.all(listPadding),
                                        itemCount: currentRequests.length,
                                        itemBuilder: (context, index) {
                                          final request = currentRequests[index];
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
                                                      child: Icon(
                                                        Icons.assignment,
                                                        size: iconCircleSize,
                                                      ),
                                                    ),
                                                    SizedBox(width: width * 0.04),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Descripción: ",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                color: Colors.black,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: request.descripcion,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight.normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: height * 0.005),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Dirección: ",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                color: Colors.black,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: request.direccionServicio,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight.normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: height * 0.005),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Fecha solicitud: ",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                color: Colors.black,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: request.fechaSolicitud
                                                                      .toIso8601String()
                                                                      .split("T")
                                                                      .first,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight.normal,
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
                                        child: Text("No hay solicitudes registradas"),
                                      ),
                              ),
                            ),

                            // Paginación: se usa Wrap para permitir salto a nueva línea
                            if (state.requests.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: height * 0.015),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: width * 0.02,
                                  runSpacing: height * 0.01,
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
                      } else if (state is RequestError) {
                        return Center(child: Text(state.message));
                      } else {
                        return const Center(child: Text("No hay solicitudes"));
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

  Widget _buildPageButton(String text, bool selected, VoidCallback onPressed) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    return Container(
      padding: EdgeInsets.all(w * 0.005),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.all(w * 0.007),
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

// --- Curva superior azul ---
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
