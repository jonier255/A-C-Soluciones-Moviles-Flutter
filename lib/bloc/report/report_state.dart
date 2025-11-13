
part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSuccess extends ReportState {
  final List<VisitWithReport> reports;
  const ReportSuccess(this.reports);

  @override
  List<Object> get props => [reports];
}

class ReportFailure extends ReportState {
  final String error;
  const ReportFailure({required this.error});

  @override
  List<Object> get props => [error];
}
