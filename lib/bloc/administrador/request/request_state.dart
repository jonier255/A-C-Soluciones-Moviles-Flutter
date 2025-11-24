import '../../../model/administrador/request_model.dart';

abstract class RequestState {}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestLoaded extends RequestState {
  final List<Request> requests;

  RequestLoaded(this.requests);

  List<Object> get props => [requests];
}

class RequestError extends RequestState {
  final String message;

  RequestError(this.message);
}
