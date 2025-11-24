part of 'view_reports_bloc.dart';

abstract class ViewReportsEvent extends Equatable {
  const ViewReportsEvent();

  @override
  List<Object> get props => [];
}

class LoadViewReports extends ViewReportsEvent {}

class LoadMoreViewReports extends ViewReportsEvent {
  final int page;
  
  const LoadMoreViewReports(this.page);
  
  @override
  List<Object> get props => [page];
}
