import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_a_c_soluciones/ui/client/Requests/requests_page.dart';

void main() {
  group('RequestsContent', () {
    testWidgets('Renderiza correctamente el widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RequestsContent(),
          ),
        ),
      );

      await tester.pump();

      // Verificar que el widget se renderiza
      expect(find.byType(RequestsContent), findsOneWidget);
    });

    testWidgets('Muestra el widget sin errores', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RequestsContent(),
          ),
        ),
      );

      // Usar pump con timeout en lugar de pumpAndSettle para evitar timeouts
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Verificar que el widget se renderiza correctamente
      expect(find.byType(RequestsContent), findsOneWidget);
    });
  });
}

