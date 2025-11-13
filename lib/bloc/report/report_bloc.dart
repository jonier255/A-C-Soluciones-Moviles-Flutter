
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/report_repository.dart';
import 'package:equatable/equatable.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository _reportRepository;

  ReportBloc({ReportRepository? reportRepository})
      : _reportRepository = reportRepository ?? ReportRepository(),
        super(ReportInitial()) {
    on<LoadReports>((event, emit) async {
      emit(ReportLoading());
      try {
        final reports = await _reportRepository.getVisitsWithReports();
        emit(ReportSuccess(reports));
      } catch (e) {
        emit(ReportFailure(error: e.toString()));
      }
    });
  }
}
