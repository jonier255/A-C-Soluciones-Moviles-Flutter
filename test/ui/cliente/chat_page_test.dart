import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_a_c_soluciones/ui/client/Chat/chat_page.dart';

void main() {
  group('ChatContent', () {
    testWidgets('Muestra el encabezado del chat con soporte técnico', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatContent(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Soporte Técnico'), findsOneWidget);
      expect(find.text('En línea'), findsOneWidget);
    });

    testWidgets('Muestra mensaje inicial cuando no hay mensajes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatContent(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Inicia una conversación'), findsOneWidget);
      expect(find.text('Escribe un mensaje para comenzar'), findsOneWidget);
    });

    testWidgets('Permite enviar un mensaje', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatContent(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Buscar el campo de texto
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Escribir un mensaje
      await tester.enterText(textField, 'Hola, necesito ayuda');
      await tester.pump();

      // Buscar el botón de enviar
      final sendButton = find.byIcon(Icons.send_rounded);
      expect(sendButton, findsOneWidget);

      // Enviar el mensaje
      await tester.tap(sendButton);
      await tester.pump();

      // Verificar que el mensaje se muestra
      expect(find.text('Hola, necesito ayuda'), findsOneWidget);

      // Esperar a que se completen los timers (600ms para la respuesta automática)
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();
    });

    testWidgets('Limpia el campo de texto después de enviar un mensaje', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatContent(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Buscar el campo de texto
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Escribir un mensaje
      await tester.enterText(textField, 'Mensaje de prueba');
      await tester.pump();

      // Enviar el mensaje
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pump();

      // Verificar que el campo está vacío
      final textFieldWidget = tester.widget<TextField>(textField);
      expect(textFieldWidget.controller?.text, isEmpty);

      // Esperar a que se completen los timers
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();
    });

    testWidgets('No envía mensaje vacío', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChatContent(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Intentar enviar sin escribir nada
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pump();

      // Verificar que no se muestra ningún mensaje del usuario
      // Solo debe estar el mensaje inicial
      expect(find.text('Inicia una conversación'), findsOneWidget);
    });
  });
}

