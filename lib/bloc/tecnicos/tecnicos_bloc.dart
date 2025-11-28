import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_a_c_soluciones/model/tecnico_model.dart';
import 'package:flutter_a_c_soluciones/repository/services_admin/tecnicos_repository.dart';

part 'tecnicos_event.dart';
part 'tecnicos_state.dart';

class TecnicosBloc extends Bloc<TecnicosEvent, TecnicosState> {
  final TecnicosRepository tecnicosRepository;

  TecnicosBloc({required this.tecnicosRepository}) : super(TecnicosInitial()) {
    on<LoadTecnicos>((event, emit) async {
      emit(TecnicosLoading());
      try {
        final response = await tecnicosRepository.getTecnicos(page: 1);
        emit(TecnicosLoaded(
          tecnicos: response.tecnicos,
          hasMorePages: response.hasMorePages,
          currentPage: 1,
          totalPages: response.totalPages,
        ));
      } catch (e) {
        emit(TecnicosError(message: e.toString()));
      }
    });

    on<LoadMoreTecnicos>((event, emit) async {
      final currentState = state;
      if (currentState is TecnicosLoaded) {
        emit(TecnicosLoadingMore(currentState.tecnicos));
        
        try {
          final response = await tecnicosRepository.getTecnicos(page: event.page);
          
          emit(TecnicosLoaded(
            tecnicos: [...currentState.tecnicos, ...response.tecnicos],
            hasMorePages: response.hasMorePages,
            currentPage: event.page,
            totalPages: response.totalPages,
          ));
        } catch (e) {
          emit(currentState);
        }
      }
    });
  }
}
