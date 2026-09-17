import 'package:flutter_state_management_showcase/data/datasources/task_local_data_source.dart';
import 'package:flutter_state_management_showcase/domain/entities/task.dart';
import 'package:flutter_state_management_showcase/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource dataSource;

  TaskRepositoryImpl(this.dataSource);

  @override
  Future<List<Task>> getTasks() => dataSource.getTasks();

  @override
  Future<Task> toggleTask(String id) => dataSource.toggleTask(id);
}
