// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_a_c_soluciones/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our splash screen shows the app name.
    expect(find.text('A&C Soluciones'), findsOneWidget);

    // Wait for the timer to complete to avoid the pending timer error.
    await tester.pumpAndSettle();
  });
}
