import 'package:flutter_state_management_showcase/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> toggleTask(String id);
}
