import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';

part 'view_reports_event.dart';
part 'view_reports_state.dart';

class ViewReportsBloc extends Bloc<ViewReportsEvent, ViewReportsState> {
  final ReportRepository reportRepository;

  ViewReportsBloc({required this.reportRepository}) : super(ViewReportsInitial()) {
    on<LoadViewReports>(_onLoadViewReports);
  }

  void _onLoadViewReports(
    LoadViewReports event,
    Emitter<ViewReportsState> emit,
  ) async {
    emit(ViewReportsLoading());
    try {
      final reports = await reportRepository.getVisitsWithReports();
      emit(ViewReportsLoaded(reports));
    } catch (e) {
      emit(ViewReportsFailure(e.toString()));
    }
  }
}
