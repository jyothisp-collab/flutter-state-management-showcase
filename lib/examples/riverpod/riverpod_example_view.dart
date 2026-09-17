import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_state_management_showcase/examples/riverpod/task_provider.dart';

class RiverpodExampleView extends ConsumerWidget {
  const RiverpodExampleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod')),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
        data: (tasks) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(tasksNotifierProvider),
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return CheckboxListTile(
                value: task.isCompleted,
                title: Text(
                  task.title,
                  style: task.isCompleted
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
                onChanged: (_) =>
                    ref.read(tasksNotifierProvider.notifier).toggle(task.id),
              );
            },
          ),
        ),
      ),
    );
  }
}
