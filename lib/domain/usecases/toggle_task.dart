import 'package:flutter_state_management_showcase/data/repositories/task_repository_impl.dart';
import 'package:flutter_state_management_showcase/domain/entities/task.dart';
import 'package:flutter_state_management_showcase/domain/repositories/task_repository.dart';

class ToggleTask {
  final TaskRepository repository;
  ToggleTask(this.repository);

  Future<Task> call(String id) async {
    final result = await repository.toggleTask(id);
    return result.when(
      success: (task) => task,
      failure: (error) => throw Exception(error.message),
    );
  }
}
