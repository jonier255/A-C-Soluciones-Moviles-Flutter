import 'package:equatable/equatable.dart';
import 'package:flutter_a_c_soluciones/model/technical/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoadingMore extends TaskState {
  final List<TaskModel> currentTasks;
  
  const TaskLoadingMore(this.currentTasks);
  
  @override
  List<Object> get props => [currentTasks];
}

class TaskSuccess extends TaskState {
  final List<TaskModel> tasks;
  final bool hasMorePages;
  final int currentPage;
  final int totalPages;
  
  const TaskSuccess(
    this.tasks, {
    this.hasMorePages = true,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  @override
  List<Object> get props => [tasks, hasMorePages, currentPage, totalPages];
}

class TaskFailure extends TaskState {
  final String error;
  const TaskFailure({required this.error});

  @override
  List<Object> get props => [error];
}
