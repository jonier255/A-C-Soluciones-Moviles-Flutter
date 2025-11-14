part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportCreationLoading extends ReportState {}

class ReportCreationSuccess extends ReportState {}

class ReportCreationFailure extends ReportState {
  final String error;
  final Map<String, String>? fieldErrors;

  const ReportCreationFailure(this.error, {this.fieldErrors});

  @override
  List<Object> get props => [error, fieldErrors ?? {}];
}