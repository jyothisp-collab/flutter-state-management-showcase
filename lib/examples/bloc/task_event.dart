import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

class ToggleTask extends TaskEvent {
  final String id;
  const ToggleTask(this.id);

  @override
  List<Object?> get props => [id];
}
