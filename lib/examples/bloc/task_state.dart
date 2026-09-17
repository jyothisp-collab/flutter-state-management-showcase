import 'package:equatable/equatable.dart';
import 'package:flutter_state_management_showcase/domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => const [];
}

class TaskInitial extends TaskState {
  const TaskInitial();

  @override
  List<Object?> get props => [];
}

class TaskLoading extends TaskState {
  const TaskLoading();

  @override
  List<Object?> get props => [];
}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  const TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
