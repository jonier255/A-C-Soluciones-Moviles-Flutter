
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/report_repository.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository _reportRepository;

  ReportBloc(this._reportRepository) : super(ReportInitial()) {
    on<FetchReports>((event, emit) async {
      print('[ReportBloc] FetchReports event received.');
      emit(ReportLoading());
      print('[ReportBloc] Emitted ReportLoading state.');
      try {
        print('[ReportBloc] Calling _reportRepository.getVisitsWithReports()...');
        final reports = await _reportRepository.getVisitsWithReports();
        print('[ReportBloc] Repository returned ${reports.length} reports.');
        emit(ReportLoaded(reports));
        print('[ReportBloc] Emitted ReportLoaded state with ${reports.length} reports.');
      } catch (e) {
        print('[ReportBloc] Caught error: ${e.toString()}');
        emit(ReportError(e.toString()));
        print('[ReportBloc] Emitted ReportError state.');
      }
    });
  }
}
