part of 'tecnicos_bloc.dart';

abstract class TecnicosEvent extends Equatable {
  const TecnicosEvent();

  @override
  List<Object> get props => [];
}

class LoadTecnicos extends TecnicosEvent {}
