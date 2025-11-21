import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_a_c_soluciones/ui/client/Home/homeClient.dart';

void main() {
  group('ClientHomeContent', () {
    testWidgets('Muestra el banner de la empresa', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClientHomeContent(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que se muestra el texto de la empresa
      expect(find.text('A & C Soluciones'), findsOneWidget);
      expect(find.text('Reparaciones y Mantenimientos'), findsOneWidget);
    });

    testWidgets('Muestra las acciones rápidas', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClientHomeContent(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que se muestran los botones de acción
      expect(find.text('Llamar'), findsOneWidget);
      expect(find.text('Servicios'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Compartir'), findsOneWidget);
    });

    testWidgets('Muestra la sección "Sobre Nosotros"', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClientHomeContent(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que se muestra la sección de información
      expect(find.text('Sobre Nosotros'), findsOneWidget);
      expect(
        find.textContaining('Somos una empresa especializada'),
        findsOneWidget,
      );
    });

    testWidgets('Muestra la calificación de la empresa', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClientHomeContent(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que se muestra la calificación
      expect(find.text('4.8'), findsOneWidget);
    });
  });
}

