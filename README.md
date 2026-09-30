# Flutter State Management Showcase

A focused Flutter reference implementation comparing three popular state management approaches side-by-side: **BLoC**, **Cubit**, and **Riverpod**. Built for client review to demonstrate how the same data flow is expressed across different patterns.

## What It Demonstrates

- **BLoC** — Event-driven state management with `BlocConsumer`, `listenWhen`/`buildWhen`, and explicit event/state transformations.
- **Cubit** — Simplified BLoC with direct method calls instead of events, reducing boilerplate for straightforward state changes.
- **Riverpod** — Compile-safe reactivity with `AsyncNotifierProvider`, `WidgetRef`, and provider composition.
- **Shared Clean Architecture data layer** — All three examples operate on the same domain/data layer, demonstrating how state management is a presentation concern independent of business logic.
- **Clean Architecture** — Strict layer separation with domain owning entities and repository contracts, data providing implementations, and presentation consuming both.
- **Material 3** — Consistent theming across all three examples with a tabbed `IndexedStack` navigation.

## Architecture Overview

```
lib/
├── main.dart                              — Composition root, tab navigation
├── core/
│   └── error/
│       ├── app_error.dart                  — AppError type
│       └── result.dart                     — Result<T> (Success / Failure)
└── features/
    └── example_feature/
        ├── data/
        │   ├── datasources/
        │   │   └── task_local_data_source.dart
        │   ├── models/
        │   │   └── task_model.dart
        │   └── repositories/
        │       └── task_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── task.dart
        │   ├── repositories/
        │   │   └── task_repository.dart
        │   └── usecases/
        │       ├── get_tasks.dart
        │       └── toggle_task.dart
        └── presentation/
            ├── views/
            │   └── task_list_view.dart
            ├── viewmodels/
            │   └── task_viewmodel.dart
            └── widgets/
                ├── task_item.dart
                └── status_widget.dart
```

### Data Flow (same across all three)

```
View → ViewModel/Bloc/Cubit/Notifier → UseCase → Repository (domain) → RepositoryImpl (data) → DataSource
```

The domain layer has zero Flutter dependencies. Each state management approach wraps the same use cases and reacts to the same `Result<T>` types.

## State Management Comparison

| Concern | BLoC | Cubit | Riverpod |
|---|---|---|---|
| State emission | `emit(state)` via events | `emit(state)` via direct calls | `state = value` in AsyncNotifier |
| Boilerplate | Event classes + state classes | State classes only | Provider definition only |
| Testability | Test events → state transitions | Test method calls → state | Test provider methods |
| Rebuild control | `buildWhen` / `listenWhen` | `listenWhen` equivalent via provider | `select` for granular rebuilds |

## Design Decisions

- **ChangeNotifier** is used for the Architecture Showcase to keep the ViewModel comparison focused on architecture rather than state-management mechanics. The same data layer powers all three examples here.
- **Equatable** on entities provides value-based equality for state comparison without manual `==` overrides.
- **Sealed `Result<T>`** makes error handling explicit — every repository method returns `Success<T>` or `Failure`, so the UI never catches unexpected exceptions.
- **No DI framework** — Dependencies are composed in `main.dart` and passed through constructors. The graph is visible in one place and requires no code generation.
- **In-memory data source** — `TaskLocalDataSource` uses an in-memory list with artificial delay to simulate async operations without network dependencies.

## Testing

Tests are organized by layer:

- **Use case tests** — Verify `GetTasks` delegates to the repository and maps `Result` correctly.
- **Data source tests** — Verify in-memory CRUD with simulated latency.
- **ViewModel tests** — Verify state transitions (loading → loaded, loading → error) and toggle behavior.

Run:

```bash
flutter pub get
flutter test
flutter analyze
```

## Out Of Scope

- Persistent storage (in-memory only).
- Networking or API calls.
- Authentication flows.
- Complex UI, animations, or navigation.
- Dependency injection frameworks.
- Comparison with other state management libraries (Provider, GetX, MobX).
