part of 'assign_visits_bloc.dart';

abstract class AssignVisitsEvent extends Equatable {
  const AssignVisitsEvent();

  @override
  List<Object> get props => [];
}

class AssignVisit extends AssignVisitsEvent {
  final VisitsModel visit;

  const AssignVisit({required this.visit});

  @override
  List<Object> get props => [visit];
}
