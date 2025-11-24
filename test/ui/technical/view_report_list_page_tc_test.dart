import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_a_c_soluciones/bloc/view_reports/view_reports_bloc.dart';
import 'package:flutter_a_c_soluciones/model/administrador/visits_model.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';
import 'package:flutter_a_c_soluciones/ui/technical/Reports/view_report_list_page_tc.dart';

class MockViewReportsBloc extends MockBloc<ViewReportsEvent, ViewReportsState>
    implements ViewReportsBloc {}

void main() {
  group('ViewReportListPageTc', () {
    late MockViewReportsBloc mockViewReportsBloc;

    setUp(() {
      mockViewReportsBloc = MockViewReportsBloc();
    });

    tearDown(() {
      mockViewReportsBloc.close();
    });

    final tVisit = VisitsModel(
      id: 1,
      fechaProgramada: DateTime.now(),
      duracionEstimada: 60,
      estado: 'completada',
      notasPrevias: 'Test pre-notes',
      notasPosteriores: 'Test post-notes',
      fechaCreacion: DateTime.now(),
      solicitudId: 1,
      tecnicoId: 1,
      servicioId: 1,
    );

    final tReport = VisitWithReport(
      visit: tVisit,
      pdfPath: '/path/to/report.pdf',
    );

    Future<void> pumpViewReportListPageTc(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ViewReportsBloc>.value(
            value: mockViewReportsBloc,
            child: const ViewReportListPageTc(),
          ),
        ),
      );
    }

    testWidgets('shows CircularProgressIndicator when state is ViewReportsLoading', (WidgetTester tester) async {
      whenListen(
        mockViewReportsBloc,
        Stream.fromIterable([ViewReportsLoading()]),
        initialState: ViewReportsLoading(),
      );

      await pumpViewReportListPageTc(tester);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows list of reports when state is ViewReportsLoaded', (WidgetTester tester) async {
      whenListen(
        mockViewReportsBloc,
        Stream.fromIterable([
          ViewReportsLoaded([tReport])
        ]),
        initialState: ViewReportsLoaded([tReport]),
      );

      await pumpViewReportListPageTc(tester);
      await tester.pump();
      await tester.pump();

      expect(find.byType(ViewReportListPageTc), findsOneWidget);
    });

    testWidgets('shows "No hay reportes disponibles." when state is ViewReportsLoaded with empty list', (WidgetTester tester) async {
      whenListen(
        mockViewReportsBloc,
        Stream.fromIterable([
          const ViewReportsLoaded([])
        ]),
        initialState: const ViewReportsLoaded([]),
      );

      await pumpViewReportListPageTc(tester);
      await tester.pump();
      await tester.pump();

      expect(find.byType(ViewReportListPageTc), findsOneWidget);
    });

    testWidgets('shows error message when state is ViewReportsFailure', (WidgetTester tester) async {
      whenListen(
        mockViewReportsBloc,
        Stream.fromIterable([const ViewReportsFailure('Test Error')]),
        initialState: const ViewReportsFailure('Test Error'),
      );

      await pumpViewReportListPageTc(tester);
      await tester.pump();
      await tester.pump();

      expect(find.byType(ViewReportListPageTc), findsOneWidget);
    });
  });
}
