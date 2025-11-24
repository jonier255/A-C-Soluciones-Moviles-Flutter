import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/model/servicio_model.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Visits/visits_details_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VisitsDetailsScreen', () {
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
      fechaProgramada: DateTime(2025, 1, 1),
      duracionEstimada: 60,
      estado: 'programada',
      notasPrevias: 'Previous notes',
      notasPosteriores: 'Posterior notes',
      fechaCreacion: DateTime.now(),
      servicio: tServicio,
    );

    testWidgets('renders task details', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VisitsDetailsScreen(task: tTask),
        ),
      );

      // Wait for the loading to finish
      await tester.pump();
      await tester.pump();

      expect(find.byType(VisitsDetailsScreen), findsOneWidget);
    });
  });
}