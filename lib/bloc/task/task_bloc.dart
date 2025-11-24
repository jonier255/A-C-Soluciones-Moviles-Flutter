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
        final response = await _taskRepository.getTasks(page: 1);
        emit(TaskSuccess(
          response.tasks,
          hasMorePages: response.hasMorePages,
          currentPage: 1,
          totalPages: response.totalPages,
        ));
      } catch (e) {
        emit(TaskFailure(error: e.toString()));
      }
    });

    on<LoadMoreTasks>((event, emit) async {
      final currentState = state;
      if (currentState is TaskSuccess) {
        emit(TaskLoadingMore(currentState.tasks));
        
        try {
          final response = await _taskRepository.getTasks(page: event.page);
          
          emit(TaskSuccess(
            response.tasks,
            hasMorePages: response.hasMorePages,
            currentPage: event.page,
            totalPages: response.totalPages,
          ));
        } catch (e) {
          emit(currentState);
        }
      }
    });

    on<UpdateTaskStatus>((event, emit) async {
      emit(TaskLoading());
      try {
        await _taskRepository.updateTaskState(int.parse(event.taskId), event.newStatus);
        final response = await _taskRepository.getTasks(page: 1);
        emit(TaskSuccess(
          response.tasks,
          hasMorePages: response.hasMorePages,
          currentPage: 1,
          totalPages: response.totalPages,
        ));
      } catch (e) {
        emit(TaskFailure(error: e.toString()));
      }
    });
  }
}