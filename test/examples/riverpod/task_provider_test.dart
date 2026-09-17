import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_state_management_showcase/domain/entities/task.dart';
import 'package:flutter_state_management_showcase/domain/repositories/task_repository.dart';
import 'package:flutter_state_management_showcase/examples/riverpod/task_provider.dart';

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
  group('TasksNotifier', () {
    test('build loads tasks from repository', () async {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            FakeRepo([Task(id: '1', title: 'A', isCompleted: false)]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final tasks = await container.read(tasksNotifierProvider.future);
      expect(tasks.length, equals(1));
      expect(tasks[0].title, equals('A'));
    });

    test('toggle updates loaded tasks', () async {
      final repo = FakeRepo([Task(id: '1', title: 'A', isCompleted: false)]);
      final container = ProviderContainer(
        overrides: [taskRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(tasksNotifierProvider.future);

      await container.read(tasksNotifierProvider.notifier).toggle('1');

      final async = container.read(tasksNotifierProvider);
      expect(async.value, isNotNull);
      expect(async.value![0].isCompleted, isTrue);
    });

    test('propagates load error', () async {
      final container = ProviderContainer(
        overrides: [
          taskRepositoryProvider
              .overrideWithValue(FakeRepo([], throwOnLoad: true)),
        ],
      );
      addTearDown(container.dispose);

      try {
        await container.read(tasksNotifierProvider.future);
        fail('Should have thrown');
      } on Exception catch (_) {
        // verified error propagated through future
      }
    });

    test('propagates toggle error', () async {
      final repo = FakeRepo([Task(id: '1', title: 'A', isCompleted: false)],
          throwOnToggle: true);
      final container = ProviderContainer(
        overrides: [taskRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(tasksNotifierProvider.future);

      await container.read(tasksNotifierProvider.notifier).toggle('1');

      final result = container.read(tasksNotifierProvider);
      expect(result.hasError, isTrue);
    });
  });
}
