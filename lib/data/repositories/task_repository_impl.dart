import 'package:flutter_state_management_showcase/core/error/result.dart';
import 'package:flutter_state_management_showcase/core/error/app_error.dart';
import 'datasources/task_local_data_source.dart';
import '../domain/entities/task.dart';
import '../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _dataSource;

  TaskRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<Task>>> getTasks() async {
    try {
      final tasks = await _dataSource.getTasks();
      return Result.success(tasks);
    } catch (e) {
      return Result.failure(UnknownError(e.toString()));
    }
  }

  @override
  Future<Result<Task>> toggleTask(String id) async {
    try {
      final task = await _dataSource.toggleTask(id);
      return Result.success(task);
    } catch (e) {
      return Result.failure(UnknownError(e.toString()));
    }
  }
}
