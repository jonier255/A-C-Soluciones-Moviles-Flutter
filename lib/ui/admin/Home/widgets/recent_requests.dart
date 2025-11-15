import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/request/request_bloc.dart';
import '../../../../bloc/request/request_state.dart';
import '../../../../model/administrador/request_model.dart';
import 'admin_home_constants.dart';
import 'package:flutter_a_c_soluciones/ui/admin/request/request_screen.dart';

/// Recent requests section with BLoC integration
class RecentRequestsSection extends StatelessWidget {
  const RecentRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AdminHomeTheme.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              "Solicitudes recientes",
              style: AdminHomeTheme.sectionTitleStyle.copyWith(
                shadows: AdminHomeTheme.textShadow(
                  color: const Color.fromARGB(255, 25, 106, 172),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<RequestBloc, RequestState>(
            builder: (context, state) {
              if (state is RequestLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is RequestLoaded) {
                final recentRequests = state.requests.take(3).toList();
                if (recentRequests.isEmpty) {
                  return const Center(
                    child: Text("No hay solicitudes recientes."),
                  );
                }

                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18.0),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AdminHomeTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(AdminHomeTheme.cardRadius),
                        boxShadow: [AdminHomeTheme.blueShadow()],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AdminHomeTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(AdminHomeTheme.cardRadius),
                        ),
                        child: Column(
                          children: recentRequests
                              .map((req) => RequestCard(request: req))
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const ViewMoreButton(),
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

/// Request card widget
class RequestCard extends StatelessWidget {
  final Request request;

  const RequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: AdminHomeTheme.backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdminHomeTheme.smallCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
        child: Row(
          children: [
            Card(
              margin: const EdgeInsets.all(0),
              elevation: 4,
              color: AdminHomeTheme.lightGray,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.build,
                  color: Colors.black,
                  size: AdminHomeTheme.quickButtonIconSize,
                ),
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
                            style: AdminHomeTheme.requestDescriptionStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            request.direccionServicio
                                .replaceAll('\n', ' ')
                                .replaceAll(RegExp(r'\s+'), ' '),
                            style: AdminHomeTheme.requestMetaStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Fecha de solicitud: ${request.fechaSolicitud}",
                            style: AdminHomeTheme.requestMetaStyle,
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 8,
                      color: AdminHomeTheme.lightGray,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AdminHomeTheme.smallCardRadius),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          request.estado,
                          style: AdminHomeTheme.statusStyle,
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

/// View more button
class ViewMoreButton extends StatelessWidget {
  const ViewMoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ).copyWith(
            shadows: AdminHomeTheme.textShadow(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
