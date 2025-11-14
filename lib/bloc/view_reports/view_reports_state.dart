part of 'view_reports_bloc.dart';

abstract class ViewReportsState extends Equatable {
  const ViewReportsState();

  @override
  List<Object> get props => [];
}

class ViewReportsInitial extends ViewReportsState {}

class ViewReportsLoading extends ViewReportsState {}

class ViewReportsLoaded extends ViewReportsState {
  final List<VisitWithReport> reports;

  const ViewReportsLoaded(this.reports);

  @override
  List<Object> get props => [reports];
}

class ViewReportsFailure extends ViewReportsState {
  final String error;

  const ViewReportsFailure(this.error);

  @override
  List<Object> get props => [error];
}
