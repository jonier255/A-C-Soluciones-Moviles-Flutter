import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/model/servicio_model.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Services/service_details_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServiceDetailsScreen', () {
    final tServicio = Servicio(
      id: 1,
      nombre: 'Test Service',
      descripcion: 'Test Description',
      estado: 'activo',
      fechaCreacion: DateTime.now(),
      fechaModificacion: DateTime.now(),
    );

    testWidgets('renders service details', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ServiceDetailsScreen(service: tServicio),
        ),
      );

      expect(find.text('Detalles del Servicio'), findsOneWidget);
      expect(find.text('Test Service'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('activo'), findsOneWidget);
    });
  });
}