import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_management_showcase/data/datasources/task_local_data_source.dart';
import 'package:flutter_state_management_showcase/data/repositories/task_repository_impl.dart';
import 'package:flutter_state_management_showcase/examples/cubit/task_cubit.dart';

class CubitExampleView extends StatelessWidget {
  const CubitExampleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TaskCubit(TaskRepositoryImpl(TaskLocalDataSource()))..loadTasks(),
      child: const _TaskList(),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cubit')),
      body: BlocConsumer<TaskCubit, TaskCubitState>(
        listenWhen: (prev, curr) => curr is TaskCubitError,
        listener: (context, state) {
          if (state is TaskCubitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        buildWhen: (prev, curr) => curr is! TaskCubitError,
        builder: (context, state) {
          if (state is TaskCubitLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TaskCubitLoaded) {
            return RefreshIndicator(
              onRefresh: () async => context.read<TaskCubit>().loadTasks(),
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
                    onChanged: (_) => context.read<TaskCubit>().toggle(task.id),
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
