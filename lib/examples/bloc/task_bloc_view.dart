import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_management_showcase/data/datasources/task_local_data_source.dart';
import 'package:flutter_state_management_showcase/data/repositories/task_repository_impl.dart';
import 'package:flutter_state_management_showcase/examples/bloc/task_bloc.dart';
import 'package:flutter_state_management_showcase/examples/bloc/task_event.dart';
import 'package:flutter_state_management_showcase/examples/bloc/task_state.dart';

class BlocExampleView extends StatelessWidget {
  const BlocExampleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskBloc(
        TaskRepositoryImpl(TaskLocalDataSource()),
      )..add(const LoadTasks()),
      child: const _TaskList(),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLoC')),
      body: BlocConsumer<TaskBloc, TaskState>(
        listenWhen: (prev, curr) => curr is TaskError,
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        buildWhen: (prev, curr) => curr is! TaskError,
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TaskLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<TaskBloc>().add(const LoadTasks()),
              child: ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return CheckboxListTile(
                    value: task.isCompleted,
                    title: Text(
                      task.title,
                      style: task.isCompleted
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough)
                          : null,
                    ),
                    onChanged: (_) =>
                        context.read<TaskBloc>().add(ToggleTask(task.id)),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
