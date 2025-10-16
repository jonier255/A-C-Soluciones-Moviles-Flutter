import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/request_repository.dart';
import 'request_event.dart';
import 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final RequestRepository repository;

  RequestBloc(this.repository) : super(RequestInitial()) {
    on<FetchRequests>((event, emit) async {
      emit(RequestLoading());
      try {
        final requests = await repository.getRequests();
        emit(RequestSuccess(requests));
      } catch (e) {
        emit(RequestError(e.toString()));
      }
    });
  }
}