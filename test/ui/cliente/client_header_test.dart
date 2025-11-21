import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_a_c_soluciones/ui/client/Header/client_header.dart';

void main() {
  group('ClientHeader', () {
    testWidgets('Muestra el nombre del usuario', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClientHeader(
              name: 'Juan Pérez',
              activity: '70%',
              onMenuPressed: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Juan Pérez'), findsOneWidget);
    });

    testWidgets('Muestra la actividad del usuario', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClientHeader(
              name: 'Juan Pérez',
              activity: '70%',
              onMenuPressed: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Actividad: 70%'), findsOneWidget);
    });

    testWidgets('Ejecuta onMenuPressed cuando se presiona el botón de menú', (WidgetTester tester) async {
      bool menuPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClientHeader(
              name: 'Juan Pérez',
              activity: '70%',
              onMenuPressed: () {
                menuPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Buscar el botón de menú por el icono
      final menuButton = find.byIcon(Icons.menu_rounded);
      expect(menuButton, findsOneWidget);

      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      expect(menuPressed, isTrue);
    });

    testWidgets('Muestra el botón de editar cuando se proporciona onEdit', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClientHeader(
              name: 'Juan Pérez',
              activity: '70%',
              onMenuPressed: () {},
              onEdit: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que se muestra el icono de editar
      expect(find.byIcon(Icons.edit_rounded), findsOneWidget);
    });

    testWidgets('No muestra el botón de editar cuando no se proporciona onEdit', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClientHeader(
              name: 'Juan Pérez',
              activity: '70%',
              onMenuPressed: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que NO se muestra el icono de editar
      expect(find.byIcon(Icons.edit_rounded), findsNothing);
    });
  });
}

