import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_a_c_soluciones/model/administrador/visits_model.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/visits_repository.dart';

part 'assign_visits_event.dart';
part 'assign_visits_state.dart';

class AssignVisitsBloc extends Bloc<AssignVisitsEvent, AssignVisitsState> {
  final VisitsRepository visitsRepository;

  AssignVisitsBloc({required this.visitsRepository}) : super(AssignVisitsInitial()) {
    on<AssignVisit>((event, emit) async {
      emit(AssignVisitsLoading());
      try {
        await visitsRepository.assignVisit(event.visit);
        emit(AssignVisitsSuccess());
      } catch (e) {
        emit(AssignVisitsFailure(error: e.toString()));
      }
    });
  }
}
