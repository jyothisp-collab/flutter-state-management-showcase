import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_management_showcase/domain/entities/task.dart';
import 'package:flutter_state_management_showcase/domain/repositories/task_repository.dart';

sealed class TaskCubitState extends Equatable {
  const TaskCubitState();

  @override
  List<Object?> get props => const [];
}

class TaskCubitInitial extends TaskCubitState {
  const TaskCubitInitial();
}

class TaskCubitLoading extends TaskCubitState {
  const TaskCubitLoading();
}

class TaskCubitLoaded extends TaskCubitState {
  final List<Task> tasks;
  const TaskCubitLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskCubitError extends TaskCubitState {
  final String message;
  const TaskCubitError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskCubit extends Cubit<TaskCubitState> {
  final TaskRepository repository;

  TaskCubit(this.repository) : super(const TaskCubitInitial());

  Future<void> loadTasks() async {
    emit(const TaskCubitLoading());
    try {
      final tasks = await repository.getTasks();
      emit(TaskCubitLoaded(tasks));
    } catch (e) {
      emit(TaskCubitError(e.toString()));
    }
  }

  Future<void> toggle(String id) async {
    try {
      final updated = await repository.toggleTask(id);
      final current = state;
      if (current is TaskCubitLoaded) {
        emit(TaskCubitLoaded(
          current.tasks.map((t) => t.id == updated.id ? updated : t).toList(),
        ));
      }
    } catch (e) {
      emit(TaskCubitError(e.toString()));
    }
  }
}
