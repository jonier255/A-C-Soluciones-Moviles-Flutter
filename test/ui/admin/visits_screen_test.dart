import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_a_c_soluciones/bloc/administrador/visits/visits_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/administrador/visits/visits_event.dart';
import 'package:flutter_a_c_soluciones/bloc/administrador/visits/visits_state.dart';
import 'package:flutter_a_c_soluciones/model/administrador/visits_model.dart';
import 'package:flutter_a_c_soluciones/ui/admin/Visits/visits_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// primero  pues se utliza un mock para una clase falsa que simula el VisitsBloc).
// Esto ayda a controlar los estados del bloc para probar la interfaz.
// Usamos la libreria bloc_test
class MockVisitsBloc extends MockBloc<VisitsEvent, VisitsState>
    implements VisitsBloc {}

void main() {
  group('VisitsScreen', () {
    // se colocan las variables que usaremos en las pruebs
    late MockVisitsBloc mockVisitsBloc;

    // 'setUp' para inicializar el mock.
    setUp(() {
      mockVisitsBloc = MockVisitsBloc();
    });

    // 'tearDown' se ejecuta despues de cada prueba para cerrar el BLoC
    tearDown(() {
      mockVisitsBloc.close();
    });

    // esta es la instancia de VisitsModel para las pruebas
    final tVisit = VisitsModel(
      id: 1,
      fechaProgramada: DateTime.now(),
      duracionEstimada: 60,
      estado: 'Pendiente',
      notasPrevias: 'Nota de prueba',
      notasPosteriores: 'Nota posterior de prueba',
      fechaCreacion: DateTime.now(),
      solicitudId: 1,
      tecnicoId: 1,
      servicioId: 1,
    );

    // Esta funcion  envuelve el widget que queremos probar en este caso pues visitsScreen
    // con los providers que necesitamos, como el BlocProvider
    Future<void> pumpVisitsScreen(WidgetTester tester) async {
      //renderizar
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<VisitsBloc>.value(
            value: mockVisitsBloc,
            child: const VisitsScreen(),
          ),
        ),
      );
    }

    // Prueba 1: vamos a probar que se muestre un CircularProgressIndicator
    testWidgets(
        'Muestra CircularProgressIndicator cuando el estado es VisitsLoading',
        (WidgetTester tester) async {
      // Preparamos el mock para el estado 'VisitsLoading' cuando se pida
      whenListen(
        mockVisitsBloc,
        Stream.fromIterable([VisitsLoading()]),
        initialState: VisitsLoading(),
      );

      // Renderizamos el widget
      await pumpVisitsScreen(tester);

      // 'pump' avanza un frame para que la interfz se actualice
      await tester.pump();

      // Verificamos que se encuentre un CircularProgressIndicator en la pantalla.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Prueba 2: miramos si se muestra la lista de visitas cuando el estado es VisitsSuccess.
    testWidgets('Muestra la lista de visitas cuando el estado es VisitsSuccess',
        (WidgetTester tester) async {
      // Preparamos el mock para VisitsSuccess que contiene una lista de prueba
      whenListen(
        mockVisitsBloc,
        Stream.fromIterable([
          VisitsSuccess([tVisit])
        ]),
        initialState: VisitsSuccess([tVisit]),
      );

      // Renderizamos el widget
      await pumpVisitsScreen(tester);
      await tester
          .pumpAndSettle(); // pumpAndSettle sirve para que todas las animaciones terminen

      // miramos que se encuentre un widget de tipo ListView.
      expect(find.byType(ListView), findsOneWidget);
      // se mira que se muestre el texto de las notas de nuestra visita de prueba.
      // Usamos byWidgetPredicate para encontrar el RichText específico.
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text
                  .toPlainText()
                  .contains('Notas previas: Nota de prueba'),
        ),
        findsOneWidget,
      );
    });

    // Prueba 3: Verificar que se muestra un mensaje de error cuando el estado es VisitsError.
    testWidgets('Muestra el mensaje de error cuando el estado es VisitsError',
        (WidgetTester tester) async {
      // Preparamos el mock para VisitsError con un mensaje de error.
      whenListen(
        mockVisitsBloc,
        Stream.fromIterable([VisitsError('Error de prueba')]),
        initialState: VisitsError('Error de prueba'),
      );

      // Renderizamos el widget.
      await pumpVisitsScreen(tester);
      await tester.pumpAndSettle();

      expect(find.text('Error de prueba'), findsOneWidget);
    });

    // Prueba 4: Verificar que se muestra un mensaje inicial cuando no hay visitas.
    testWidgets('Muestra "No hay visitas" cuando el estado es VisitsInitial',
        (WidgetTester tester) async {
      whenListen(
        mockVisitsBloc,
        Stream.fromIterable([VisitsInitial()]),
        initialState: VisitsInitial(),
      );

      // Renderizamos el widget.
      await pumpVisitsScreen(tester);
      await tester.pumpAndSettle();

      // Verificamos que muestre "No hay visitas".
      expect(find.text('No hay visitas'), findsOneWidget);
    });
  });
}
