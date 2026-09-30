import 'package:flutter_state_management_showcase/data/repositories/task_repository_impl.dart';
import 'package:flutter_state_management_showcase/domain/entities/task.dart';
import 'package:flutter_state_management_showcase/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;
  GetTasks(this.repository);

  Future<List<Task>> call() async {
    final result = await repository.getTasks();
    return result.when(
      success: (tasks) => tasks,
      failure: (error) => throw Exception(error.message),
    );
  }
}
