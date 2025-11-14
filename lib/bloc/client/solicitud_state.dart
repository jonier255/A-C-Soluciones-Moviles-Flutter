import '../../model/client/solicitud_model.dart';

abstract class SolicitudState {}

class SolicitudInitial extends SolicitudState {}

class SolicitudLoading extends SolicitudState {}

class SolicitudSuccess extends SolicitudState {
  final List<Solicitud> solicitudes;
  SolicitudSuccess(this.solicitudes);
}

class SolicitudError extends SolicitudState {
  final String message;
  SolicitudError(this.message);
}
