import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_a_c_soluciones/ui/technical/Services/service_information.dart';

void main() {
  testWidgets('ServiceDetailScreen renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ServiceDetailScreen()));

    expect(find.text('Informacion del servicio'), findsOneWidget);
    expect(find.text('Suministro, instalacion y mantenimiento a brazos hidraulicos'), findsNWidgets(2));
    expect(find.text('Mantenimiento e instalacion'), findsOneWidget);
  });
}