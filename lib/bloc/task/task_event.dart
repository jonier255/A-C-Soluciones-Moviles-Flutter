import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class LoadMoreTasks extends TaskEvent {
  final int page;
  
  const LoadMoreTasks(this.page);
  
  @override
  List<Object> get props => [page];
}

class UpdateTaskStatus extends TaskEvent {
  final String taskId;
  final String newStatus;

  const UpdateTaskStatus({required this.taskId, required this.newStatus});

  @override
  List<Object> get props => [taskId, newStatus];
}