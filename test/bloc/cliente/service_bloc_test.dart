import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_a_c_soluciones/bloc/client/service_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/client/service_event.dart';
import 'package:flutter_a_c_soluciones/bloc/client/service_state.dart';
import 'package:flutter_a_c_soluciones/model/client/service_model.dart';
import 'package:flutter_a_c_soluciones/repository/client/service_api_service.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock para ServiceRepository - caso éxito
class MockServiceRepositorySuccess implements ServiceRepository {
  @override
  Future<List<ServiceModel>> getServices() async {
    return [
      ServiceModel(
        id: 1,
        nombre: 'Servicio 1',
        descripcion: 'Descripción del servicio 1',
        estado: 'activo',
        price: 100,
        fechaCreacion: DateTime.now(),
        fechaModificacion: DateTime.now(),
        creadaPorFk: 1,
      ),
      ServiceModel(
        id: 2,
        nombre: 'Servicio 2',
        descripcion: 'Descripción del servicio 2',
        estado: 'activo',
        price: 200,
        fechaCreacion: DateTime.now(),
        fechaModificacion: DateTime.now(),
        creadaPorFk: 1,
      ),
    ];
  }
}

// Mock para ServiceRepository - caso error
class MockServiceRepositoryFailure implements ServiceRepository {
  @override
  Future<List<ServiceModel>> getServices() async {
    throw Exception('Error al cargar los servicios');
  }
}

void main() {
  group('ServiceBloc', () {
    late ServiceBloc serviceBloc;

    test('initial state is ServiceInitial', () {
      serviceBloc = ServiceBloc(MockServiceRepositorySuccess());
      expect(serviceBloc.state, isA<ServiceInitial>());
    });

    blocTest<ServiceBloc, ServiceState>(
      'emits [ServiceLoading, ServiceSuccess] when FetchService is added and services are loaded successfully.',
      build: () => ServiceBloc(MockServiceRepositorySuccess()),
      act: (bloc) => bloc.add(FetchService()),
      expect: () => [
        isA<ServiceLoading>(),
        isA<ServiceSuccess>(),
      ],
      verify: (bloc) {
        final state = bloc.state as ServiceSuccess;
        expect(state.services.length, 2);
        expect(state.services[0].nombre, 'Servicio 1');
        expect(state.services[1].nombre, 'Servicio 2');
      },
    );

    blocTest<ServiceBloc, ServiceState>(
      'emits [ServiceLoading, ServiceError] when FetchService is added and loading fails.',
      build: () => ServiceBloc(MockServiceRepositoryFailure()),
      act: (bloc) => bloc.add(FetchService()),
      expect: () => [
        isA<ServiceLoading>(),
        isA<ServiceError>(),
      ],
      verify: (bloc) {
        final state = bloc.state as ServiceError;
        expect(state.message, contains('Error al cargar los servicios'));
      },
    );

    blocTest<ServiceBloc, ServiceState>(
      'emits correct ServiceSuccess state with empty list when repository returns empty list.',
      build: () => ServiceBloc(_MockServiceRepositoryEmpty()),
      act: (bloc) => bloc.add(FetchService()),
      expect: () => [
        isA<ServiceLoading>(),
        isA<ServiceSuccess>(),
      ],
      verify: (bloc) {
        final state = bloc.state as ServiceSuccess;
        expect(state.services.length, 0);
      },
    );
  });
}

// Mock para ServiceRepository - caso lista vacía
class _MockServiceRepositoryEmpty implements ServiceRepository {
  @override
  Future<List<ServiceModel>> getServices() async {
    return [];
  }
}

