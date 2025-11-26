import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_a_c_soluciones/bloc/view_reports/view_reports_bloc.dart';
import 'package:flutter_a_c_soluciones/model/administrador/visits_model.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'report_bloc_test.mocks.dart';

@GenerateMocks([ReportRepository])
void main() {
  group('ViewReportsBloc', () {
    late MockReportRepository mockReportRepository;

    setUp(() {
      mockReportRepository = MockReportRepository();
    });

    test('initial state is ViewReportsInitial', () {
      final reportBloc = ViewReportsBloc(reportRepository: mockReportRepository);
      expect(reportBloc.state, ViewReportsInitial());
    });

    blocTest<ViewReportsBloc, ViewReportsState>(
      'emits [ViewReportsLoading, ViewReportsLoaded] when LoadViewReports is added and fetching is successful',
      build: () {
        when(mockReportRepository.getVisitsWithReports(page: anyNamed('page'), perPage: anyNamed('perPage'))).thenAnswer(
          (_) async => ReportResponse(
            reports: [
              VisitWithReport(
                visit: VisitsModel(
                  id: 1,
                  fechaProgramada: DateTime.now(),
                  duracionEstimada: 60,
                  estado: 'completada',
                  notasPrevias: 'Notas previas',
                  notasPosteriores: 'Notas posteriores',
                  fechaCreacion: DateTime.now(),
                  solicitudId: 1,
                  tecnicoId: 1,
                  servicioId: 1,
                ),
                pdfPath: 'path/to/report.pdf',
              ),
            ],
            hasMorePages: false,
            totalPages: 1,
          ),
        );
        return ViewReportsBloc(reportRepository: mockReportRepository);
      },
      act: (bloc) => bloc.add(LoadViewReports()),
      expect: () => [
        ViewReportsLoading(),
        isA<ViewReportsLoaded>(),
      ],
      verify: (_) {
        verify(mockReportRepository.getVisitsWithReports(page: 1)).called(1);
      },
    );

    blocTest<ViewReportsBloc, ViewReportsState>(
      'emits [ViewReportsLoading, ViewReportsFailure] when LoadViewReports is added and fetching fails',
      build: () {
        when(mockReportRepository.getVisitsWithReports(page: anyNamed('page'), perPage: anyNamed('perPage'))).thenThrow(Exception('Failed to load reports'));
        return ViewReportsBloc(reportRepository: mockReportRepository);
      },
      act: (bloc) => bloc.add(LoadViewReports()),
      expect: () => [
        ViewReportsLoading(),
        const ViewReportsFailure('Exception: Failed to load reports'),
      ],
      verify: (_) {
        verify(mockReportRepository.getVisitsWithReports(page: 1)).called(1);
      },
    );
  });
}
