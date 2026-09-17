import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_state_management_showcase/domain/entities/task.dart';
import 'package:flutter_state_management_showcase/domain/repositories/task_repository.dart';
import 'package:flutter_state_management_showcase/examples/cubit/task_cubit.dart';

class FakeRepo implements TaskRepository {
  final List<Task> _tasks;
  final bool throwOnLoad;
  final bool throwOnToggle;

  FakeRepo(this._tasks, {this.throwOnLoad = false, this.throwOnToggle = false});

  @override
  Future<List<Task>> getTasks() async {
    if (throwOnLoad) throw Exception('Load failed');
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task> toggleTask(String id) async {
    if (throwOnToggle) throw Exception('Toggle failed');
    final i = _tasks.indexWhere((t) => t.id == id);
    return _tasks[i].copyWith(isCompleted: !_tasks[i].isCompleted);
  }
}

void main() {
  group('TaskCubit', () {
    test('initial state is TaskCubitInitial', () {
      final cubit = TaskCubit(FakeRepo([]));
      expect(cubit.state.runtimeType, equals(TaskCubitInitial));
      cubit.close();
    });

    test('loadTasks transitions to TaskCubitLoaded', () async {
      final cubit = TaskCubit(FakeRepo([
        Task(id: '1', title: 'A', isCompleted: false),
      ]));
      addTearDown(cubit.close);

      await cubit.loadTasks();

      expect(cubit.state.runtimeType, equals(TaskCubitLoaded));
      final loaded = cubit.state as TaskCubitLoaded;
      expect(loaded.tasks.length, equals(1));
      expect(loaded.tasks[0].title, equals('A'));
    });

    test('loadTasks transitions to TaskCubitError on failure', () async {
      final cubit = TaskCubit(FakeRepo([], throwOnLoad: true));
      addTearDown(cubit.close);

      await cubit.loadTasks();

      expect(cubit.state.runtimeType, equals(TaskCubitError));
    });

    test('toggle updates task completion in list', () async {
      final cubit = TaskCubit(FakeRepo([
        Task(id: '1', title: 'A', isCompleted: false),
      ]));
      addTearDown(cubit.close);

      await cubit.loadTasks();
      await cubit.toggle('1');

      final loaded = cubit.state as TaskCubitLoaded;
      expect(loaded.tasks[0].isCompleted, isTrue);
    });

    test('toggle transitions to TaskCubitError on failure', () async {
      final cubit = TaskCubit(FakeRepo([
        Task(id: '1', title: 'A', isCompleted: false),
      ], throwOnToggle: true));
      addTearDown(cubit.close);

      await cubit.loadTasks();
      await cubit.toggle('1');

      expect(cubit.state.runtimeType, equals(TaskCubitError));
    });
  });
}
