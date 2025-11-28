part of 'assign_visits_bloc.dart';

abstract class AssignVisitsState extends Equatable {
  const AssignVisitsState();

  @override
  List<Object> get props => [];
}

class AssignVisitsInitial extends AssignVisitsState {}

class AssignVisitsLoading extends AssignVisitsState {}

class AssignVisitsSuccess extends AssignVisitsState {}

class AssignVisitsFailure extends AssignVisitsState {
  final String error;

  const AssignVisitsFailure({required this.error});

  @override
  List<Object> get props => [error];
}
