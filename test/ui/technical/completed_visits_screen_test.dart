import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_event.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_state.dart';
import 'package:flutter_a_c_soluciones/model/servicio_model.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Visits/completed_visits_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

void main() {
  group('CompletedVisitsScreen', () {
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

    final tTaskCompleted = TaskModel(
      id: 1,
      fechaProgramada: DateTime.now(),
      duracionEstimada: 60,
      estado: 'completada',
      notasPrevias: 'Previous notes',
      notasPosteriores: 'Posterior notes',
      fechaCreacion: DateTime.now(),
      servicio: tServicio,
    );

    final tTaskPending = TaskModel(
      id: 2,
      fechaProgramada: DateTime.now(),
      duracionEstimada: 60,
      estado: 'Pendiente',
      notasPrevias: 'Previous notes',
      notasPosteriores: 'Posterior notes',
      fechaCreacion: DateTime.now(),
      servicio: tServicio,
    );

    Future<void> pumpCompletedVisitsScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>.value(
            value: mockTaskBloc,
            child: const CompletedVisitsScreen(),
          ),
        ),
      );
    }

    testWidgets('shows CircularProgressIndicator when state is TaskLoading', (WidgetTester tester) async {
      whenListen(
        mockTaskBloc,
        Stream.fromIterable([TaskLoading()]),
        initialState: TaskLoading(),
      );

      await pumpCompletedVisitsScreen(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows list of completed visits when state is TaskSuccess', (WidgetTester tester) async {
      whenListen(
        mockTaskBloc,
        Stream.fromIterable([
          TaskSuccess([tTaskCompleted, tTaskPending])
        ]),
        initialState: TaskSuccess([tTaskCompleted, tTaskPending]),
      );

      await pumpCompletedVisitsScreen(tester);
      await tester.pump();
      await tester.pump();

      expect(find.byType(CompletedVisitsScreen), findsOneWidget);
    });

    testWidgets('shows "No hay visitas terminadas." when state is TaskSuccess with no completed tasks', (WidgetTester tester) async {
      whenListen(
        mockTaskBloc,
        Stream.fromIterable([
          TaskSuccess([tTaskPending])
        ]),
        initialState: TaskSuccess([tTaskPending]),
      );

      await pumpCompletedVisitsScreen(tester);
      await tester.pump();
      await tester.pump();

      expect(find.byType(CompletedVisitsScreen), findsOneWidget);
    });

    testWidgets('shows error message when state is TaskFailure', (WidgetTester tester) async {
      whenListen(
        mockTaskBloc,
        Stream.fromIterable([const TaskFailure(error: 'Test Error')]),
        initialState: const TaskFailure(error: 'Test Error'),
      );

      await pumpCompletedVisitsScreen(tester);
      await tester.pump();
      await tester.pump();

      expect(find.byType(CompletedVisitsScreen), findsOneWidget);
    });
  });
}