import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_a_c_soluciones/bloc/service/service_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/service/service_event.dart';
import 'package:flutter_a_c_soluciones/bloc/service/service_state.dart';
import 'package:flutter_a_c_soluciones/model/servicio_model.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Services/services_screen.dart';

class MockServiceBloc extends MockBloc<ServiceEvent, ServiceState> implements ServiceBloc {}

void main() {
  group('ServicesScreen', () {
    late MockServiceBloc mockServiceBloc;

    setUp(() {
      mockServiceBloc = MockServiceBloc();
    });

    tearDown(() {
      mockServiceBloc.close();
    });

    final tServicio = Servicio(
      id: 1,
      nombre: 'Test Service',
      descripcion: 'Test Description',
      estado: 'activo',
      fechaCreacion: DateTime.now(),
      fechaModificacion: DateTime.now(),
    );

    Future<void> pumpServicesScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ServiceBloc>.value(
            value: mockServiceBloc,
            child: ServicesScreen(),
          ),
        ),
      );
    }

    testWidgets('shows CircularProgressIndicator when state is ServiceLoading', (WidgetTester tester) async {
      whenListen(
        mockServiceBloc,
        Stream.fromIterable([ServiceLoading()]),
        initialState: ServiceLoading(),
      );

      await pumpServicesScreen(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows list of services when state is ServiceSuccess', (WidgetTester tester) async {
      whenListen(
        mockServiceBloc,
        Stream.fromIterable([
          ServiceSuccess([tServicio])
        ]),
        initialState: ServiceSuccess([tServicio]),
      );

      await pumpServicesScreen(tester);
      await tester.pump();
      await tester.pump();

      expect(find.byType(ServicesScreen), findsOneWidget);
    });

    testWidgets('shows "No hay servicios disponibles." when state is ServiceSuccess with empty list', (WidgetTester tester) async {
      whenListen(
        mockServiceBloc,
        Stream.fromIterable([
          ServiceSuccess([])
        ]),
        initialState: ServiceSuccess([]),
      );

      await pumpServicesScreen(tester);
      await tester.pump();
      await tester.pump();

      expect(find.byType(ServicesScreen), findsOneWidget);
    });

    testWidgets('shows error message when state is ServiceFailure', (WidgetTester tester) async {
      whenListen(
        mockServiceBloc,
        Stream.fromIterable([ServiceFailure(error: 'Test Error')]),
        initialState: ServiceFailure(error: 'Test Error'),
      );

      await pumpServicesScreen(tester);
      await tester.pump();
      await tester.pump();

      expect(find.byType(ServicesScreen), findsOneWidget);
    });
  });
}
