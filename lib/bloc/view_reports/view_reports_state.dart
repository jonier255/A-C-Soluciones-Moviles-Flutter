part of 'view_reports_bloc.dart';

abstract class ViewReportsState extends Equatable {
  const ViewReportsState();

  @override
  List<Object> get props => [];
}

class ViewReportsInitial extends ViewReportsState {}

class ViewReportsLoading extends ViewReportsState {}

class ViewReportsLoadingMore extends ViewReportsState {
  final List<VisitWithReport> currentReports;
  
  const ViewReportsLoadingMore(this.currentReports);
  
  @override
  List<Object> get props => [currentReports];
}

class ViewReportsLoaded extends ViewReportsState {
  final List<VisitWithReport> reports;
  final bool hasMorePages;
  final int currentPage;
  final int totalPages;

  const ViewReportsLoaded(
    this.reports, {
    this.hasMorePages = true,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  @override
  List<Object> get props => [reports, hasMorePages, currentPage, totalPages];
}

class ViewReportsFailure extends ViewReportsState {
  final String error;

  const ViewReportsFailure(this.error);

  @override
  List<Object> get props => [error];
}
