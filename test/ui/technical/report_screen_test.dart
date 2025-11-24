import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Reports/report_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ReportScreen renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReportScreen(visitId: 1)));

    expect(find.text('Generar Reporte'), findsOneWidget);
    expect(find.text('Pantalla para generar reporte'), findsOneWidget);
  });
}