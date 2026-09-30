import 'dart:async';
import '../domain/entities/task.dart';
import '../domain/repositories/task_repository.dart';

class TaskLocalDataSource {
  final List<Task> _tasks = [
    Task(id: '1', title: 'Review project architecture', isCompleted: true),
    Task(id: '2', title: 'Implement user authentication', isCompleted: false),
    Task(id: '3', title: 'Write unit tests for repositories', isCompleted: false),
    Task(id: '4', title: 'Set up CI/CD pipeline', isCompleted: false),
    Task(id: '5', title: 'Update documentation', isCompleted: true),
  ];

  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_tasks);
  }

  Future<Task> toggleTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) throw StateError('Task $id not found');
    _tasks[index] = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
    return _tasks[index];
  }
}
