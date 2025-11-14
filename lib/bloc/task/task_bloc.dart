import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_event.dart';
import 'package:flutter_a_c_soluciones/bloc/task/task_state.dart';
import 'package:flutter_a_c_soluciones/repository/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;

  TaskBloc({TaskRepository? taskRepository})
      : _taskRepository = taskRepository ?? TaskRepository(),
        super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await _taskRepository.getTasks();
        emit(TaskSuccess(tasks));
      } catch (e) {
        emit(TaskFailure(error: e.toString()));
      }
    });

    on<UpdateTaskStatus>((event, emit) async {
      emit(TaskLoading());
      try {
        await _taskRepository.updateTaskState(int.parse(event.taskId), event.newStatus);
        final tasks = await _taskRepository.getTasks(); // Reload tasks after update
        emit(TaskSuccess(tasks));
      } catch (e) {
        emit(TaskFailure(error: e.toString()));
      }
    });
  }
}