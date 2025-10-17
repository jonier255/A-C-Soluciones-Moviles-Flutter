import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess extends TaskState {
  final List<TaskModel> tasks;
  TaskSuccess(this.tasks);
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
