import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_a_c_soluciones/bloc/client/solicitud_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/client/solicitud_event.dart';
import 'package:flutter_a_c_soluciones/bloc/client/solicitud_state.dart';
import 'package:flutter_a_c_soluciones/model/client/solicitud_model.dart';
import 'package:flutter_a_c_soluciones/repository/client/solicitud_api_solicitud.dart';

// Mock para SolicitudApiRepository - caso éxito
class MockSolicitudApiRepositorySuccess implements SolicitudApiRepository {
  @override
  Future<List<Solicitud>> getSolicitudes() async {
    return [
      Solicitud(
        id: 1,
        fechaSolicitud: '2024-01-01T00:00:00',
        estado: 'pendiente',
        direccionServicio: 'Calle Test 123',
        descripcion: 'Descripción de la solicitud 1',
        comentarios: 'Comentarios de la solicitud 1',
        clienteId: 1,
        servicioId: 1,
      ),
      Solicitud(
        id: 2,
        fechaSolicitud: '2024-01-02T00:00:00',
        estado: 'en_proceso',
        direccionServicio: 'Calle Test 456',
        descripcion: 'Descripción de la solicitud 2',
        comentarios: 'Comentarios de la solicitud 2',
        clienteId: 1,
        servicioId: 2,
        tecnicoId: 1,
      ),
    ];
  }

  @override
  Future<Solicitud> getSolicitudById(int solicitudId) async {
    return Solicitud(
      id: solicitudId,
      fechaSolicitud: '2024-01-01T00:00:00',
      estado: 'pendiente',
      direccionServicio: 'Calle Test 123',
      descripcion: 'Descripción de la solicitud',
      comentarios: 'Comentarios',
      clienteId: 1,
      servicioId: 1,
    );
  }

  @override
  Future<Solicitud> crearSolicitud({
    required int clienteId,
    required int servicioId,
    required String direccion,
    required String descripcion,
    String comentarios = '',
    DateTime? fechaSolicitud,
  }) async {
    return Solicitud(
      id: 3,
      fechaSolicitud: (fechaSolicitud ?? DateTime.now()).toIso8601String(),
      estado: 'pendiente',
      direccionServicio: direccion,
      descripcion: descripcion,
      comentarios: comentarios,
      clienteId: clienteId,
      servicioId: servicioId,
    );
  }
}

// Mock para SolicitudApiRepository - caso error
class MockSolicitudApiRepositoryFailure implements SolicitudApiRepository {
  @override
  Future<List<Solicitud>> getSolicitudes() async {
    throw Exception('Error al cargar las solicitudes');
  }

  @override
  Future<Solicitud> getSolicitudById(int solicitudId) async {
    throw Exception('Error al cargar la solicitud');
  }

  @override
  Future<Solicitud> crearSolicitud({
    required int clienteId,
    required int servicioId,
    required String direccion,
    required String descripcion,
    String comentarios = '',
    DateTime? fechaSolicitud,
  }) async {
    throw Exception('Error al crear solicitud');
  }
}

void main() {
  group('SolicitudBloc', () {
    late SolicitudBloc solicitudBloc;

    test('initial state is SolicitudInitial', () {
      solicitudBloc = SolicitudBloc(MockSolicitudApiRepositorySuccess());
      expect(solicitudBloc.state, isA<SolicitudInitial>());
    });

    blocTest<SolicitudBloc, SolicitudState>(
      'emits [SolicitudLoading, SolicitudSuccess] when FetchSolicitud is added and solicitudes are loaded successfully.',
      build: () => SolicitudBloc(MockSolicitudApiRepositorySuccess()),
      act: (bloc) => bloc.add(FetchSolicitud()),
      expect: () => [
        isA<SolicitudLoading>(),
        isA<SolicitudSuccess>(),
      ],
      verify: (bloc) {
        final state = bloc.state as SolicitudSuccess;
        expect(state.solicitudes.length, 2);
        expect(state.solicitudes[0].id, 1);
        expect(state.solicitudes[0].estado, 'pendiente');
        expect(state.solicitudes[1].id, 2);
        expect(state.solicitudes[1].estado, 'en_proceso');
      },
    );

    blocTest<SolicitudBloc, SolicitudState>(
      'emits [SolicitudLoading, SolicitudError] when FetchSolicitud is added and loading fails.',
      build: () => SolicitudBloc(MockSolicitudApiRepositoryFailure()),
      act: (bloc) => bloc.add(FetchSolicitud()),
      expect: () => [
        isA<SolicitudLoading>(),
        isA<SolicitudError>(),
      ],
      verify: (bloc) {
        final state = bloc.state as SolicitudError;
        expect(state.message, contains('Error al cargar las solicitudes'));
      },
    );

    blocTest<SolicitudBloc, SolicitudState>(
      'emits correct SolicitudSuccess state with empty list when repository returns empty list.',
      build: () => SolicitudBloc(_MockSolicitudApiRepositoryEmpty()),
      act: (bloc) => bloc.add(FetchSolicitud()),
      expect: () => [
        isA<SolicitudLoading>(),
        isA<SolicitudSuccess>(),
      ],
      verify: (bloc) {
        final state = bloc.state as SolicitudSuccess;
        expect(state.solicitudes.length, 0);
      },
    );
  });
}

// Mock para SolicitudApiRepository - caso lista vacía
class _MockSolicitudApiRepositoryEmpty implements SolicitudApiRepository {
  @override
  Future<List<Solicitud>> getSolicitudes() async {
    return [];
  }

  @override
  Future<Solicitud> getSolicitudById(int solicitudId) async {
    throw UnimplementedError();
  }

  @override
  Future<Solicitud> crearSolicitud({
    required int clienteId,
    required int servicioId,
    required String direccion,
    required String descripcion,
    String comentarios = '',
    DateTime? fechaSolicitud,
  }) async {
    throw UnimplementedError();
  }
}