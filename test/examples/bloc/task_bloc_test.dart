import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_state_management_showcase/domain/entities/task.dart';
import 'package:flutter_state_management_showcase/domain/repositories/task_repository.dart';
import 'package:flutter_state_management_showcase/examples/bloc/task_bloc.dart';
import 'package:flutter_state_management_showcase/examples/bloc/task_event.dart';
import 'package:flutter_state_management_showcase/examples/bloc/task_state.dart';

class FakeRepo implements TaskRepository {
  final List<Task> _tasks;
  final bool failOnLoad;
  final bool failOnToggle;

  FakeRepo(this._tasks, {this.failOnLoad = false, this.failOnToggle = false});

  @override
  Future<List<Task>> getTasks() async {
    if (failOnLoad) throw Exception('Load failed');
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task> toggleTask(String id) async {
    if (failOnToggle) throw Exception('Toggle failed');
    final i = _tasks.indexWhere((t) => t.id == id);
    return _tasks[i].copyWith(isCompleted: !_tasks[i].isCompleted);
  }
}

void main() {
  group('TaskBloc', () {
    test('initial state is TaskInitial', () {
      final bloc = TaskBloc(FakeRepo([]));
      bloc.close();
      expect(bloc.state.runtimeType, equals(TaskInitial));
    });

    test('LoadTasks transitions to Loaded', () async {
      final bloc = TaskBloc(FakeRepo([
        Task(id: '1', title: 'A', isCompleted: false),
      ]));
      addTearDown(bloc.close);

      bloc.add(const LoadTasks());
      await bloc.stream.skip(1).firstWhere(
            (s) => s is TaskLoaded || s is TaskError,
            orElse: () => throw StateError('No terminal state'),
          );

      expect(bloc.state.runtimeType, equals(TaskLoaded));
      final loaded = bloc.state as TaskLoaded;
      expect(loaded.tasks.length, equals(1));
      expect(loaded.tasks[0].title, equals('A'));
    });

    test('LoadTasks transitions to Error on failure', () async {
      final bloc = TaskBloc(FakeRepo([], failOnLoad: true));
      addTearDown(bloc.close);

      bloc.add(const LoadTasks());
      await bloc.stream.skip(1).firstWhere(
            (s) => s is TaskLoaded || s is TaskError,
            orElse: () => throw StateError('No terminal state'),
          );

      expect(bloc.state.runtimeType, equals(TaskError));
    });

    test('ToggleTask updates task completion', () async {
      final bloc = TaskBloc(FakeRepo([
        Task(id: '1', title: 'A', isCompleted: false),
      ]));
      addTearDown(bloc.close);

      bloc.add(const LoadTasks());
      await bloc.stream.skip(1).firstWhere(
            (s) => s is TaskLoaded,
            orElse: () => throw StateError('No loaded state'),
          );

      bloc.add(const ToggleTask('1'));
      await bloc.stream.firstWhere(
        (s) => s is TaskLoaded || s is TaskError,
        orElse: () => throw StateError('No terminal state'),
          );

      final loaded = bloc.state as TaskLoaded;
      expect(loaded.tasks[0].isCompleted, isTrue);
    });

    test('ToggleTask transitions to Error on failure', () async {
      final bloc = TaskBloc(FakeRepo([
        Task(id: '1', title: 'A', isCompleted: false),
      ], failOnToggle: true));
      addTearDown(bloc.close);

      bloc.add(const LoadTasks());
      await bloc.stream.skip(1).firstWhere(
            (s) => s is TaskLoaded,
            orElse: () => throw StateError('No loaded state'),
          );

      bloc.add(const ToggleTask('1'));
      await bloc.stream.firstWhere(
        (s) => s is TaskError,
        orElse: () => throw StateError('No error state'),
      );

      expect(bloc.state.runtimeType, equals(TaskError));
    });
  });
}
