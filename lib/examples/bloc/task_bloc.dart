import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_management_showcase/domain/repositories/task_repository.dart';
import 'package:flutter_state_management_showcase/examples/bloc/task_event.dart';
import 'package:flutter_state_management_showcase/examples/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(const TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<ToggleTask>(_onToggleTask);
  }

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      final tasks = await repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTask(
    ToggleTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final updated = await repository.toggleTask(event.id);
      final current = state;
      if (current is TaskLoaded) {
        emit(TaskLoaded(
          current.tasks.map((t) => t.id == updated.id ? updated : t).toList(),
        ));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
