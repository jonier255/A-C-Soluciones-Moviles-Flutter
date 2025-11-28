import '../../../model/administrador/visits_model.dart';

abstract class VisitsState {}
class VisitsInitial extends VisitsState {}
class VisitsLoading extends VisitsState {}
class VisitsSuccess extends VisitsState {
  final List<VisitsModel> visits;
  VisitsSuccess(this.visits);
}
class VisitsError extends VisitsState {
  final String message;
  VisitsError(this.message);
}