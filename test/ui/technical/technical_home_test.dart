import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_event.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_state.dart';
import 'package:flutter_a_c_soluciones/model/servicio_model.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Home/technical_home.dart';

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

void main() {
  group('TechnicalHomeScreen', () {
    late MockTaskBloc mockTaskBloc;

    setUp(() {
      mockTaskBloc = MockTaskBloc();
    });

    tearDown(() {
      mockTaskBloc.close();
    });

    final tServicio = Servicio(
      id: 1,
      nombre: 'Test Service',
      descripcion: 'Test Description',
      estado: 'activo',
      fechaCreacion: DateTime.now(),
      fechaModificacion: DateTime.now(),
    );

    final tTask = TaskModel(
      id: 1,
      fechaProgramada: DateTime.now(),
      duracionEstimada: 60,
      estado: 'Pendiente',
      notasPrevias: 'Previous notes',
      notasPosteriores: 'Posterior notes',
      fechaCreacion: DateTime.now(),
      servicio: tServicio,
    );

    Future<void> pumpTechnicalHomeScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>.value(
            value: mockTaskBloc,
            child: TechnicalHomeScreen(),
          ),
        ),
      );
    }

    testWidgets('renders header and main buttons', (WidgetTester tester) async {
      whenListen(
        mockTaskBloc,
        Stream.fromIterable([TaskInitial()]),
        initialState: TaskInitial(),
      );

      await pumpTechnicalHomeScreen(tester);

      expect(find.widgetWithText(TextField, 'Buscar tarea o cliente'), findsOneWidget);
      expect(find.text('Asignadas'), findsOneWidget);
      expect(find.text('Reportes'), findsOneWidget);
      expect(find.text('Servicios'), findsOneWidget);
      expect(find.text('Finalizadas'), findsOneWidget);
      expect(find.text('Tareas recientes'), findsOneWidget);
    });

    testWidgets('shows loading indicator when state is TaskLoading', (WidgetTester tester) async {
      whenListen(
        mockTaskBloc,
        Stream.fromIterable([TaskLoading()]),
        initialState: TaskLoading(),
      );

      await pumpTechnicalHomeScreen(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });



    testWidgets('shows recent tasks when state is TaskSuccess', (WidgetTester tester) async {
      whenListen(
        mockTaskBloc,
        Stream.fromIterable([
          TaskSuccess([tTask])
        ]),
        initialState: TaskSuccess([tTask]),
      );

      await pumpTechnicalHomeScreen(tester);
      await tester.pumpAndSettle();

      expect(find.text('Tareas recientes'), findsOneWidget);
      expect(find.text('Test Service'), findsOneWidget);
    });

    testWidgets('shows "No hay tareas recientes." when state is TaskSuccess with empty list', (WidgetTester tester) async {
      whenListen(
        mockTaskBloc,
        Stream.fromIterable([
          TaskSuccess([])
        ]),
        initialState: TaskSuccess([]),
      );

      await pumpTechnicalHomeScreen(tester);
      await tester.pumpAndSettle();

      expect(find.text('No hay tareas recientes.'), findsOneWidget);
    });

    testWidgets('shows error message when state is TaskFailure', (WidgetTester tester) async {
      whenListen(
        mockTaskBloc,
        Stream.fromIterable([TaskFailure(error: 'Test Error')]),
        initialState: TaskFailure(error: 'Test Error'),
      );

      await pumpTechnicalHomeScreen(tester);
      await tester.pumpAndSettle();

      expect(find.text('Test Error'), findsOneWidget);
    });
  });
}