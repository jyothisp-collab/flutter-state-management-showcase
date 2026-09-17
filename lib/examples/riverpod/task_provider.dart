import 'package:riverpod/riverpod.dart';
import 'package:flutter_state_management_showcase/domain/entities/task.dart';
import 'package:flutter_state_management_showcase/domain/repositories/task_repository.dart';
import 'package:flutter_state_management_showcase/data/repositories/task_repository_impl.dart';
import 'package:flutter_state_management_showcase/data/datasources/task_local_data_source.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(TaskLocalDataSource());
});

final tasksNotifierProvider = AsyncNotifierProvider<TasksNotifier, List<Task>>(
  TasksNotifier.new,
);

class TasksNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    final repo = ref.read(taskRepositoryProvider);
    return repo.getTasks();
  }

  Future<void> toggle(String id) async {
    final current = state.value;
    if (current == null) return;

    try {
      final repo = ref.read(taskRepositoryProvider);
      final updated = await repo.toggleTask(id);
      state = AsyncData(
        current.map((t) => t.id == updated.id ? updated : t).toList(),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
