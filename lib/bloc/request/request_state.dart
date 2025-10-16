import '../../model/request_model.dart';

abstract class RequestState {}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestSuccess extends RequestState {
  final List<Request> requests;

  RequestSuccess(this.requests);
}

class RequestError extends RequestState {
  final String message;

  RequestError(this.message);
}

