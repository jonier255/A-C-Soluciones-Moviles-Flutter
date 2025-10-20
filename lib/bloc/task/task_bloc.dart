import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_event.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_state.dart';
import 'package:flutter_a_c_soluciones/repository/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;

  TaskBloc(this._taskRepository) : super(TaskInitial()) {
    on<FetchTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await _taskRepository.getTasks();
        emit(TaskSuccess(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });
  }
}