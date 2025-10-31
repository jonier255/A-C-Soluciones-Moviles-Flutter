import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_a_c_soluciones/model/client/solicitud_model.dart';
import 'package:flutter_a_c_soluciones/repository/client/solicitud_api_solicitud.dart';

class RequestsContent extends StatefulWidget {
  const RequestsContent({super.key});

  @override
  State<RequestsContent> createState() => _RequestsContentState();
}

class _RequestsContentState extends State<RequestsContent> {
  final SolicitudApiRepository _repository = SolicitudApiRepository();
  late Future<List<Solicitud>> _futureSolicitudes;
  int _currentPage = 0;
  static const int _itemsPerPage = 6;

  // contar la cantidad de solicitudes
  int cantidadSolicitudes = 0;

  @override
  void initState() {
    super.initState();
    _futureSolicitudes = _repository.getSolicitudes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 220,
          alignment: Alignment.center,
          color: const Color.fromARGB(255, 176, 223, 255),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<List<Solicitud>>(
                future: _futureSolicitudes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.blue);
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Error al cargar',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text(
                      'Sin solicitudes',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    );
                  }

                  final solicitudes = snapshot.data!;
                  final pendientes = solicitudes
                      .where(
                          (s) => s.estado.trim().toLowerCase() == 'pendiente')
                      .length;
                  final enProceso = solicitudes
                      .where(
                          (s) => s.estado.trim().toLowerCase() == 'en proceso')
                      .length;
                  final completadas = solicitudes
                      .where(
                          (s) => s.estado.trim().toLowerCase() == 'completado')
                      .length;

                  final total = pendientes + enProceso + completadas;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fila con el título
                      const Padding(
                        padding: EdgeInsets.only(bottom: 0, left: 5),
                        child: Text(
                          'Estado de las solicitudes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // Fila con el botón y el gráfico de pastel
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Gráfico de pastel a la derecha
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      color: Colors.orange,
                                      value: pendientes.toDouble(),
                                      title:
                                          'Pendiente\n${((pendientes / total) * 100).toStringAsFixed(1)}%',
                                      radius: 45,
                                      titleStyle: const TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                    PieChartSectionData(
                                      color: Colors.blue,
                                      value: enProceso.toDouble(),
                                      title:
                                          'En proceso\n${((enProceso / total) * 100).toStringAsFixed(1)}%',
                                      radius: 45,
                                      titleStyle: const TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                    PieChartSectionData(
                                      color: Colors.green,
                                      value: completadas.toDouble(),
                                      title:
                                          'Completado\n${((completadas / total) * 100).toStringAsFixed(1)}%',
                                      radius: 45,
                                      titleStyle: const TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ],
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 30,
                                ),
                              ),
                            ),
                            // Botón a la izquierda
                            ElevatedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.pushNamed(
                                    context, '/crear-solicitud');

                                if (result == true) {
                                  setState(() {
                                    _futureSolicitudes =
                                        _repository.getSolicitudes();
                                  });
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Nueva solicitud"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Solicitud>>(
            future: _futureSolicitudes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No hay solicitudes disponibles",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final solicitudes = snapshot.data!;
              final totalPages = (solicitudes.length / _itemsPerPage).ceil();
              final startIndex = _currentPage * _itemsPerPage;
              final endIndex = (_currentPage + 1) * _itemsPerPage;

              final currentSolicitudes = solicitudes.sublist(
                startIndex,
                endIndex > solicitudes.length ? solicitudes.length : endIndex,
              );

              return LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: currentSolicitudes.length,
                              padding: const EdgeInsets.all(12),
                              itemBuilder: (context, index) {
                                final solicitud = currentSolicitudes[index];
                                return Card(
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                  elevation: 4,
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.request_page,
                                      color: Color.fromARGB(255, 46, 145, 216),
                                      size: 40,
                                    ),
                                    title: Text(
                                      DateFormat('dd/MM/yyyy HH:mm').format(
                                          DateTime.parse(
                                              solicitud.fechaSolicitud)),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    subtitle: Text(
                                      solicitud.descripcion,
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Text(
                                      solicitud.estado,
                                      // cambiar color segun estado
                                      style: TextStyle(
                                        color: solicitud.estado.toLowerCase() ==
                                                'pendiente'
                                            ? Colors.orange
                                            : solicitud.estado.toLowerCase() ==
                                                    'en proceso'
                                                ? Colors.blue
                                                : Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios),
                                onPressed: _currentPage > 0
                                    ? () {
                                        setState(() {
                                          _currentPage--;
                                        });
                                      }
                                    : null,
                              ),
                              Text(
                                "Página ${_currentPage + 1} de $totalPages",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: _currentPage < totalPages - 1
                                    ? () {
                                        setState(() {
                                          _currentPage++;
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
