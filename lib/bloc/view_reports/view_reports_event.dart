part of 'view_reports_bloc.dart';

abstract class ViewReportsEvent extends Equatable {
  const ViewReportsEvent();

  @override
  List<Object> get props => [];
}

class LoadViewReports extends ViewReportsEvent {}
