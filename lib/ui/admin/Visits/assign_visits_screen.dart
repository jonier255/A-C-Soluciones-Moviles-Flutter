import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/request/request_event.dart';
import 'package:flutter_a_c_soluciones/bloc/request/request_state.dart';
import 'package:flutter_a_c_soluciones/bloc/visits/assign_visits/assign_visits_bloc.dart';
import 'package:flutter_a_c_soluciones/model/administrador/visits_model.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/visits_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_a_c_soluciones/bloc/tecnicos/tecnicos_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/request/request_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/servicios/servicios_bloc.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/tecnicos_repository.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/request_repository.dart';
import 'package:flutter_a_c_soluciones/repository/service_repository.dart';

class AssignVisitsScreen extends StatelessWidget {
  const AssignVisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AssignVisitsBloc(visitsRepository: VisitsRepository()),
        ),
        BlocProvider(
          create: (context) =>
              TecnicosBloc(tecnicosRepository: TecnicosRepository())
                ..add(LoadTecnicos()),
        ),
        BlocProvider(
          create: (context) =>
              RequestBloc(RequestRepository())..add(FetchRequests()),
        ),
        BlocProvider(
          create: (context) =>
              ServiciosBloc(serviceRepository: ServiceRepository())
                ..add(LoadServicios()),
        ),
      ],
      child: const AssignVisitsView(),
    );
  }
}

class AssignVisitsView extends StatefulWidget {
  const AssignVisitsView({super.key});

  @override
  _AssignVisitsViewState createState() => _AssignVisitsViewState();
}

class _AssignVisitsViewState extends State<AssignVisitsView> {
  final _formKey = GlobalKey<FormState>();
  final _fechaProgramadaController = TextEditingController();
  final _duracionEstimadaController = TextEditingController();
  final _notasPreviasController = TextEditingController();
  final _notasPosterioresController = TextEditingController();

  int? _selectedTecnicoId;
  int? _selectedSolicitudId;
  int? _selectedServicioId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final pagePadding = width * 0.05; 
    final smallGap = height * 0.015;
    final mediumGap = height * 0.025;
    final largeGap = height * 0.04; 
    final accentBlue = const Color(0xFF3875F7);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: accentBlue,
        elevation: 9,
        title: const Text(
          'Asignar Visita',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AssignVisitsBloc, AssignVisitsState>(
        listener: (context, state) {
          if (state is AssignVisitsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Visita asignada con éxito')),
            );
            Navigator.pop(context);
          } else if (state is AssignVisitsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(pagePadding),
          child: Card(
            color: Colors.white,
            elevation: 6,
            shadowColor: accentBlue.withOpacity(0.9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(pagePadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Detalles de la visita",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: accentBlue,
                      ),
                    ),
                    SizedBox(height: mediumGap),
                    _buildFechaProgramadaField(),
                    SizedBox(height: smallGap),
                    _buildDuracionEstimadaField(),
                    SizedBox(height: smallGap),
                    _buildNotasPreviasField(),
                    SizedBox(height: smallGap),
                    _buildNotasPosterioresField(),
                    SizedBox(height: mediumGap),
                    const Divider(),
                    Text(
                      "Selección de datos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: accentBlue,
                      ),
                    ),
                    SizedBox(height: mediumGap),
                    _buildTecnicosDropdown(),
                    SizedBox(height: smallGap),
                    _buildSolicitudesDropdown(),
                    SizedBox(height: smallGap),
                    _buildServiciosDropdown(),
                    SizedBox(height: largeGap),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(vertical: height * 0.018, horizontal: width * 0.04),
                              elevation: 3,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final visit = VisitsModel(
                                  id: 0,
                                  fechaProgramada: DateFormat('yyyy-MM-dd HH:mm').parse(_fechaProgramadaController.text),
                                  duracionEstimada: int.parse(_duracionEstimadaController.text),
                                  estado: 'Programada',
                                  notasPrevias: _notasPreviasController.text,
                                  notasPosteriores: '',
                                  fechaCreacion: DateTime.now(),
                                  solicitudId: _selectedSolicitudId!,
                                  tecnicoId: _selectedTecnicoId!,
                                  servicioId: _selectedServicioId!,
                                );
                                context.read<AssignVisitsBloc>().add(AssignVisit(visit: visit));
                              }
                            },
                            label: const Text(
                              'Asignar Visita',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.03),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.clear, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(vertical: height * 0.018),
                              elevation: 8,
                            ),
                            onPressed: () {
                              setState(() {
                                _fechaProgramadaController.clear();
                                _duracionEstimadaController.clear();
                                _notasPreviasController.clear();
                                _notasPosterioresController.clear();
                                _selectedTecnicoId = null;
                                _selectedSolicitudId = null;
                                _selectedServicioId = null;
                                _formKey.currentState?.reset();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Campos limpiados')),
                              );
                            },
                            label: const Text(
                              'Limpiar Campos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final accentBlue = const Color(0xFF3875F7);
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, color: accentBlue) : null,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(vertical: height * 0.018, horizontal: width * 0.03),
    );
  }

  Widget _fieldContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFechaProgramadaField() {
    return _fieldContainer(
      TextFormField(
        controller: _fechaProgramadaController,
        readOnly: true,
        decoration: _inputDecoration('Fecha Programada', icon: Icons.calendar_month),
      onTap: () async {
        FocusScope.of(context).unfocus();
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) {
            final dateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            _fechaProgramadaController.text =
                DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
          }
        }
        },
        validator: (value) =>
            value == null || value.isEmpty ? 'Por favor ingrese la fecha' : null,
      ),
    );
  }

  Widget _buildDuracionEstimadaField() {
    return _fieldContainer(
      TextFormField(
        controller: _duracionEstimadaController,
        keyboardType: TextInputType.number,
        decoration: _inputDecoration('Duración Estimada (minutos)', icon: Icons.timer),
        validator: (value) =>
            value == null || value.isEmpty ? 'Por favor ingrese la duración' : null,
      ),
    );
  }

  Widget _buildNotasPreviasField() {
    return _fieldContainer(
      TextFormField(
        controller: _notasPreviasController,
        decoration: _inputDecoration('Notas Previas', icon: Icons.edit_note),
        maxLines: 2,
      ),
    );
  }

  Widget _buildNotasPosterioresField() {
    return _fieldContainer(
      TextFormField(
        controller: _notasPosterioresController,
        decoration: _inputDecoration('Notas Posteriores', icon: Icons.notes),
        maxLines: 2,
      ),
    );
  }

  Widget _buildTecnicosDropdown() {
    return BlocBuilder<TecnicosBloc, TecnicosState>(
      builder: (context, state) {
        if (state is TecnicosLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TecnicosLoaded) {
          return _fieldContainer(
            DropdownButtonFormField<int>(
            isExpanded: true,
            value: _selectedTecnicoId,
            decoration: _inputDecoration('Seleccione un técnico', icon: Icons.engineering),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF3875F7)),
            items: state.tecnicos.map((tecnico) {
              return DropdownMenuItem<int>(
                value: tecnico.id,
                child: Text(
                  '${tecnico.nombre} ${tecnico.apellido}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedTecnicoId = value),
            validator: (value) =>
                value == null ? 'Por favor seleccione un técnico' : null,
            ),
          );
        }
        if (state is TecnicosError) {
          return Text('Error: ${state.message}');
        }
        return Container();
      },
    );
  }

  Widget _buildSolicitudesDropdown() {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        if (state is RequestLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RequestLoaded) {
          return _fieldContainer(
            DropdownButtonFormField<int>(
            isExpanded: true,
            value: _selectedSolicitudId,
            decoration: _inputDecoration('Seleccione una solicitud', icon: Icons.assignment),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF3875F7)),
            items: state.requests.map((solicitud) {
              return DropdownMenuItem<int>(
                value: solicitud.id,
                child: Text(
                  solicitud.descripcion,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedSolicitudId = value),
            validator: (value) =>
                value == null ? 'Por favor seleccione una solicitud' : null,
            ),
          );
        }
        if (state is RequestError) {
          return Text('Error: ${state.message}');
        }
        return Container();
      },
    );
  }

  Widget _buildServiciosDropdown() {
    return BlocBuilder<ServiciosBloc, ServiciosState>(
      builder: (context, state) {
        if (state is ServiciosLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ServiciosLoaded) {
          return _fieldContainer(
            DropdownButtonFormField<int>(
            isExpanded: true,
            value: _selectedServicioId,
            decoration: _inputDecoration('Seleccione un servicio', icon: Icons.home_repair_service),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF3875F7)),
            items: state.servicios.map((servicio) {
              return DropdownMenuItem<int>(
                value: servicio.id,
                child: Text(
                  servicio.nombre,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedServicioId = value),
            validator: (value) =>
                value == null ? 'Por favor seleccione un servicio' : null,
            ),
          );
        }
        if (state is ServiciosError) {
          return Text('Error: ${state.message}');
        }
        return Container();
      },
    );
  }

  
}
