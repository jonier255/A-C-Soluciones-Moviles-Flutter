import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_a_c_soluciones/repository/report_repository.dart';

part 'view_reports_event.dart';
part 'view_reports_state.dart';

class ViewReportsBloc extends Bloc<ViewReportsEvent, ViewReportsState> {
  final ReportRepository reportRepository;

  ViewReportsBloc({required this.reportRepository}) : super(ViewReportsInitial()) {
    on<LoadViewReports>(_onLoadViewReports);
    on<LoadMoreViewReports>(_onLoadMoreViewReports);
  }

  void _onLoadViewReports(
    LoadViewReports event,
    Emitter<ViewReportsState> emit,
  ) async {
    emit(ViewReportsLoading());
    try {
      final response = await reportRepository.getVisitsWithReports(page: 1);
      emit(ViewReportsLoaded(
        response.reports,
        hasMorePages: response.hasMorePages,
        currentPage: 1,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(ViewReportsFailure(e.toString()));
    }
  }

  void _onLoadMoreViewReports(
    LoadMoreViewReports event,
    Emitter<ViewReportsState> emit,
  ) async {
    final currentState = state;
    if (currentState is ViewReportsLoaded) {
      emit(ViewReportsLoadingMore(currentState.reports));
      
      try {
        final response = await reportRepository.getVisitsWithReports(page: event.page);
        
        emit(ViewReportsLoaded(
          response.reports,
          hasMorePages: response.hasMorePages,
          currentPage: event.page,
          totalPages: response.totalPages,
        ));
      } catch (e) {
        emit(currentState);
      }
    }
  }
}
