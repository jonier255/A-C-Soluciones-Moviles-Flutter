import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/repository/client/service_api_service.dart';
import 'package:flutter_a_c_soluciones/model/client/service_model.dart';
import 'package:flutter_a_c_soluciones/ui/client/Requests/create/create_request_modal.dart';
import 'package:flutter_a_c_soluciones/repository/client/solicitud_api_solicitud.dart';

class ServicesContent extends StatefulWidget {
  final int clienteId;

  ServicesContent({Key? key, required this.clienteId}) : super(key: key);

  @override
  State<ServicesContent> createState() => _ServicesContentState();
}

class _ServicesContentState extends State<ServicesContent> {
  final ServiceRepository _repository = ServiceRepository();
  late Future<List<ServiceModel>> _futureServices;
  int _currentPage = 0;
  static const int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _futureServices = _repository.getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 220,
          alignment: Alignment.center,
          color: const Color.fromARGB(255, 212, 212, 212),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Contador de solicitudes ---
              FutureBuilder<List<ServiceModel>>(
                future: _futureServices,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.blue);
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Error',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    );
                  } else if (snapshot.hasData) {
                    final servicios = snapshot.data!;
                    return Text(
                      '${servicios.length} Servicios',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  } else {
                    return const Text(
                      '0',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<ServiceModel>>(
            future: _futureServices,
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
                  child: Text("No hay servicios disponibles"),
                );
              }

              final services = snapshot.data!;
              final totalPages = (services.length / _itemsPerPage).ceil();
              final startIndex = _currentPage * _itemsPerPage;
              final endIndex = (_currentPage + 1) * _itemsPerPage;
              final currentServices = services.sublist(
                startIndex,
                endIndex > services.length ? services.length : endIndex,
              );

              return LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: currentServices.length,
                                  padding: const EdgeInsets.all(12),
                                  itemBuilder: (context, index) {
                                    final service = currentServices[index];
                                    return GestureDetector(
                                      onTap: () async {
                                        final result = await showDialog(
                                          context: context,
                                          builder: (_) => CrearSolicitudModal(
                                            clienteId: widget.clienteId,
                                            servicio: service,
                                            repository:
                                                SolicitudApiRepository(),
                                          ),
                                        );
                                        if (result == true) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: const [
                                                  Icon(Icons.check_circle,
                                                      color: Colors.white),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      'Solicitud creada con éxito',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              backgroundColor:
                                                  Colors.green.shade600,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              margin: const EdgeInsets.only(
                                                top:
                                                    20, // margen superior para que salga desde arriba
                                                left: 16,
                                                right: 16,
                                              ),
                                              elevation: 8,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(1),
                                        ),
                                        elevation: 4,
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.build_circle_rounded,
                                            color: Color.fromARGB(
                                                255, 46, 145, 216),
                                            size: 40,
                                          ),
                                          title: Text(
                                            service.nombre,
                                            // mostrar menos caracteres si es muy largo
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          subtitle: Text(
                                            service.descripcion,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: Text(
                                            "\$${service.price}",
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
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
                      ));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
