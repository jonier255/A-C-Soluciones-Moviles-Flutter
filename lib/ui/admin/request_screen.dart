import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/request_bloc.dart';
import '../../bloc/request_event.dart';
import '../../bloc/request_state.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RequestBloc>().add(FetchRequests());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitudes'),
      ),
      body: BlocBuilder<RequestBloc, RequestState>(
        builder: (context, state) {
          if (state is RequestLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is RequestSuccess) {
            return ListView.builder(
              itemCount: state.requests.length,
              itemBuilder: (context, index) {
                final request = state.requests[index];
                return ListTile(
                  title: Text(request.descripcion),
                  subtitle: Text(request.direccionServicio),
                  trailing: Text(request.fechaSolicitud.toIso8601String().split('T').first),
                );
              },
            );
          } else if (state is RequestError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No hay solicitudes'));
          }
        },
      ),
    );
  }
}
