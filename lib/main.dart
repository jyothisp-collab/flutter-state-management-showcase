import 'package:flutter/material.dart';
import 'package:flutter_state_management_showcase/examples/bloc/task_bloc_view.dart';
import 'package:flutter_state_management_showcase/examples/cubit/cubit_example_view.dart';
import 'package:flutter_state_management_showcase/examples/riverpod/riverpod_example_view.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Management Showcase',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const _ExampleSelector(),
    );
  }
}

class _ExampleSelector extends StatefulWidget {
  const _ExampleSelector();

  @override
  State<_ExampleSelector> createState() => _ExampleSelectorState();
}

class _ExampleSelectorState extends State<_ExampleSelector>
    with SingleTickerProviderStateMixin {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('State Management')),
      body: IndexedStack(
        index: _index,
        children: const [
          BlocExampleView(),
          CubitExampleView(),
          RiverpodExampleView(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.account_tree), label: 'BLoC'),
          NavigationDestination(icon: Icon(Icons.public), label: 'Cubit'),
          NavigationDestination(icon: Icon(Icons.water), label: 'Riverpod'),
        ],
      ),
    );
  }
}
