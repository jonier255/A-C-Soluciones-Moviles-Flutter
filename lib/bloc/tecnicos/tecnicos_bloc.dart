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
        final tecnicos = await tecnicosRepository.getTecnicos();
        emit(TecnicosLoaded(tecnicos: tecnicos));
      } catch (e) {
        emit(TecnicosError(message: e.toString()));
      }
    });
  }
}
