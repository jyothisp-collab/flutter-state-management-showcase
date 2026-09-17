import 'package:flutter_state_management_showcase/domain/entities/task.dart';

class TaskLocalDataSource {
  final List<Task> _tasks = [
    const Task(id: '1', title: 'Review architecture layers', isCompleted: true),
    const Task(id: '2', title: 'Define domain entities', isCompleted: true),
    const Task(
        id: '3', title: 'Implement repository pattern', isCompleted: false),
    const Task(id: '4', title: 'Write unit tests', isCompleted: false),
    const Task(id: '5', title: 'Document design decisions', isCompleted: false),
  ];

  Future<List<Task>> getTasks() async {
    return List.unmodifiable(_tasks);
  }

  Future<Task> toggleTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    final updated =
        _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
    _tasks[index] = updated;
    return updated;
  }
}
