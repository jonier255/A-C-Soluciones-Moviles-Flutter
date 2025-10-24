
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/report_repository.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository _reportRepository;

  ReportBloc(this._reportRepository) : super(ReportInitial()) {
    on<FetchReports>((event, emit) async {
      emit(ReportLoading());
      try {
        final reports = await _reportRepository.getVisitsWithReports();
        emit(ReportLoaded(reports));
      } catch (e) {
        emit(ReportError(e.toString()));
      }
    });
  }
}
