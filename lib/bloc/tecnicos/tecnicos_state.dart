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
  final bool hasMorePages;
  final int currentPage;
  final int totalPages;

  const TecnicosLoaded({
    required this.tecnicos,
    this.hasMorePages = false,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  @override
  List<Object> get props => [tecnicos, hasMorePages, currentPage, totalPages];
}

class TecnicosLoadingMore extends TecnicosState {
  final List<Tecnico> currentTecnicos;

  const TecnicosLoadingMore(this.currentTecnicos);

  @override
  List<Object> get props => [currentTecnicos];
}

class TecnicosError extends TecnicosState {
  final String message;

  const TecnicosError({required this.message});

  @override
  List<Object> get props => [message];
}
