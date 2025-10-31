import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/services_admin/service_api_visits.dart';
import 'package:flutter_a_c_soluciones/bloc/visits/visits_event.dart';
import 'package:flutter_a_c_soluciones/bloc/visits/visits_state.dart';

class VisitsBloc extends Bloc<VisitsEvent, VisitsState> {
  final VisitsRepository repository;

  VisitsBloc(this.repository) : super(VisitsInitial()) {
    on<FetchVisits>((event, emit) async {
      emit(VisitsLoading());
      try {
        final visits = await repository.getVisits();
        emit(VisitsSuccess(visits));
      } catch (e) {
        emit(VisitsError(e.toString()));
      }
    });
  }
}
