import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_a_c_soluciones/model/servicio_model.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Visits/visits_details_screen.dart';

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
      await tester.pumpAndSettle();

      expect(find.text('Detalles de la Visita'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Previous notes'), findsOneWidget);
      expect(find.text('Posterior notes'), findsOneWidget);
      expect(find.text('2025-01-01'), findsOneWidget);
      expect(find.text('60 minutos'), findsOneWidget);
      expect(find.text('Generar reporte'), findsOneWidget);
    });
  });
}