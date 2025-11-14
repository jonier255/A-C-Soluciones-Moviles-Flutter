import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class UpdateTaskStatus extends TaskEvent {
  final String taskId;
  final String newStatus;

  const UpdateTaskStatus({required this.taskId, required this.newStatus});

  @override
  List<Object> get props => [taskId, newStatus];
}