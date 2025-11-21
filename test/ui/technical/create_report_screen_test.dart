import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_a_c_soluciones/bloc/report/report_bloc.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Reports/create_report_screen.dart';

class MockReportBloc extends MockBloc<ReportEvent, ReportState> implements ReportBloc {}

void main() {
  group('CreateReportScreen', () {
    late MockReportBloc mockReportBloc;

    setUp(() {
      mockReportBloc = MockReportBloc();
    });

    tearDown(() {
      mockReportBloc.close();
    });

    Future<void> pumpCreateReportScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ReportBloc>.value(
            value: mockReportBloc,
            child: CreateReportScreen(visitId: 1),
          ),
        ),
      );
    }

    testWidgets('renders form fields', (WidgetTester tester) async {
      whenListen(
        mockReportBloc,
        Stream.fromIterable([ReportInitial()]),
        initialState: ReportInitial(),
      );

      await pumpCreateReportScreen(tester);

      expect(find.text('Crear Reporte de Mantenimiento'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(9));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows loading indicator when state is ReportCreationLoading', (WidgetTester tester) async {
      whenListen(
        mockReportBloc,
        Stream.fromIterable([ReportCreationLoading()]),
        initialState: ReportCreationLoading(),
      );

      await pumpCreateReportScreen(tester);

      expect(find.text('Generando Reporte...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing); 
    });

    testWidgets('shows success message when state is ReportCreationSuccess', (WidgetTester tester) async {
      whenListen(
        mockReportBloc,
        Stream.fromIterable([ReportCreationSuccess()]),
        initialState: ReportInitial(),
      );

      await pumpCreateReportScreen(tester);
      
      mockReportBloc.emit(ReportCreationSuccess());
      await tester.pump();

    });

    testWidgets('shows error message when state is ReportCreationFailure', (WidgetTester tester) async {
      whenListen(
        mockReportBloc,
        Stream.fromIterable([ReportCreationFailure('Test Error')]),
        initialState: ReportInitial(),
      );

      await pumpCreateReportScreen(tester);
      
      mockReportBloc.emit(ReportCreationFailure('Test Error'));
      await tester.pump();

    });
  });
}