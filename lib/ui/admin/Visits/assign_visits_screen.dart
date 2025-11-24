import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/request/request_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/request/request_event.dart';
import 'package:flutter_a_c_soluciones/bloc/request/request_state.dart';
import 'package:flutter_a_c_soluciones/bloc/servicios/servicios_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/tecnicos/tecnicos_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/visits/assign_visits/assign_visits_bloc.dart';
import 'package:flutter_a_c_soluciones/model/administrador/visits_model.dart';
import 'package:flutter_a_c_soluciones/repository/service_repository.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/request_repository.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/tecnicos_repository.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/visits_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'widgets/assign_visits_constants.dart';
import 'widgets/assign_visits_widgets.dart';
import 'widgets/form_fields.dart';

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
    return Scaffold(
      backgroundColor: AssignVisitsTheme.backgroundColor,
      appBar: _buildAppBar(context),
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
          padding: EdgeInsets.all(AssignVisitsTheme.pagePadding(size.width)),
          child: _buildFormCard(context, size),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AssignVisitsTheme.accentBlue,
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
    );
  }

  Widget _buildFormCard(BuildContext context, Size size) {
    final padding = AssignVisitsTheme.pagePadding(size.width);
    return Card(
      color: AssignVisitsTheme.cardColor,
      elevation: 6,
      shadowColor: AssignVisitsTheme.accentBlue.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(title: "Detalles de la visita"),
              SizedBox(height: AssignVisitsTheme.mediumGap(size.height)),
              DateTimeField(
                controller: _fechaProgramadaController,
                label: 'Fecha Programada',
              ),
              SizedBox(height: AssignVisitsTheme.smallGap(size.height)),
              NumericField(
                controller: _duracionEstimadaController,
                label: 'Duración Estimada (minutos)',
                icon: Icons.timer,
                errorMessage: 'Por favor ingrese la duración',
              ),
              SizedBox(height: AssignVisitsTheme.smallGap(size.height)),
              NotesField(
                controller: _notasPreviasController,
                label: 'Notas Previas',
                icon: Icons.edit_note,
              ),
              SizedBox(height: AssignVisitsTheme.smallGap(size.height)),
              NotesField(
                controller: _notasPosterioresController,
                label: 'Notas Posteriores',
              ),
              SizedBox(height: AssignVisitsTheme.mediumGap(size.height)),
              const Divider(),
              const SectionTitle(title: "Selección de datos"),
              SizedBox(height: AssignVisitsTheme.mediumGap(size.height)),
              _buildTecnicosDropdown(),
              SizedBox(height: AssignVisitsTheme.smallGap(size.height)),
              _buildSolicitudesDropdown(),
              SizedBox(height: AssignVisitsTheme.smallGap(size.height)),
              _buildServiciosDropdown(),
              SizedBox(height: AssignVisitsTheme.largeGap(size.height)),
              _buildActionButtons(context, size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Size size) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: AssignVisitsTheme.accentBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(
                vertical: AssignVisitsTheme.buttonVerticalPadding(size.height),
                horizontal: AssignVisitsTheme.buttonHorizontalPadding(size.width),
              ),
              elevation: 3,
            ),
            onPressed: () => _submitForm(context),
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
        SizedBox(width: AssignVisitsTheme.buttonSpacing(size.width)),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.clear, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(
                vertical: AssignVisitsTheme.buttonVerticalPadding(size.height),
              ),
              elevation: 8,
            ),
            onPressed: () => _clearForm(context),
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
    );
  }

  void _submitForm(BuildContext context) {
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
  }

  void _clearForm(BuildContext context) {
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
  }

  Widget _buildTecnicosDropdown() {
    return BlocBuilder<TecnicosBloc, TecnicosState>(
      builder: (context, state) {
        if (state is TecnicosLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TecnicosLoaded) {
          return FieldContainer(
            child: DropdownButtonFormField<int>(
              isExpanded: true,
              initialValue: _selectedTecnicoId,
              decoration: buildInputDecoration(context, 'Seleccione un técnico', icon: Icons.engineering),
              icon: const Icon(Icons.arrow_drop_down, color: AssignVisitsTheme.accentBlue),
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
              validator: (value) => value == null ? 'Por favor seleccione un técnico' : null,
            ),
          );
        }
        if (state is TecnicosError) {
          return Text('Error: ${state.message}', style: const TextStyle(color: Colors.red));
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
          return FieldContainer(
            child: DropdownButtonFormField<int>(
              isExpanded: true,
              initialValue: _selectedSolicitudId,
              decoration: buildInputDecoration(context, 'Seleccione una solicitud', icon: Icons.assignment),
              icon: const Icon(Icons.arrow_drop_down, color: AssignVisitsTheme.accentBlue),
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
              validator: (value) => value == null ? 'Por favor seleccione una solicitud' : null,
            ),
          );
        }
        if (state is RequestError) {
          return Text('Error: ${state.message}', style: const TextStyle(color: Colors.red));
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
          return FieldContainer(
            child: DropdownButtonFormField<int>(
              isExpanded: true,
              initialValue: _selectedServicioId,
              decoration: buildInputDecoration(context, 'Seleccione un servicio', icon: Icons.home_repair_service),
              icon: const Icon(Icons.arrow_drop_down, color: AssignVisitsTheme.accentBlue),
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
              validator: (value) => value == null ? 'Por favor seleccione un servicio' : null,
            ),
          );
        }
        if (state is ServiciosError) {
          return Text('Error: ${state.message}', style: const TextStyle(color: Colors.red));
        }
        return Container();
      },
    );
  }
}
