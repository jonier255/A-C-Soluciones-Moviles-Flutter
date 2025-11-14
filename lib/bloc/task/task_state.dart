import 'package:equatable/equatable.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess extends TaskState {
  final List<TaskModel> tasks;
  const TaskSuccess(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskFailure extends TaskState {
  final String error;
  const TaskFailure({required this.error});

  @override
  List<Object> get props => [error];
}
