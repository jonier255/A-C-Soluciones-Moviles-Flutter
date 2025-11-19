part of 'tecnicos_bloc.dart';

abstract class TecnicosState extends Equatable {
  const TecnicosState();

  @override
  List<Object> get props => [];
}

class TecnicosInitial extends TecnicosState {}

class TecnicosLoading extends TecnicosState {}

class TecnicosLoaded extends TecnicosState {
  final List<Tecnico> tecnicos;

  const TecnicosLoaded({required this.tecnicos});

  @override
  List<Object> get props => [tecnicos];
}

class TecnicosError extends TecnicosState {
  final String message;

  const TecnicosError({required this.message});

  @override
  List<Object> get props => [message];
}
