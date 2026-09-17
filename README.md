# Flutter State Management Showcase

This repository demonstrates three popular Flutter state management approaches: **BLoC**, **Cubit**, and **Riverpod**.

By implementing the same basic task-management (To-Do) functionality across all three approaches, this repository provides a practical comparison of their concepts, syntax, and behaviors.

## Approaches Demonstrated

*   **Cubit**: A lightweight state management solution from the `bloc` package. It manages state by exposing functions that can be called directly to emit new states. It's simpler than BLoC and great for most use cases.
*   **BLoC (Business Logic Component)**: A more strict, event-driven pattern where the UI sends *Events* to the BLoC, which then transforms them into *States*. It requires more boilerplate than Cubit but offers robust traceability and advanced event transformations (like debouncing).
*   **Riverpod**: A modern, compile-safe reactivity framework. Instead of widgets depending on a tree hierarchy, Riverpod uses global providers that are read safely via a `WidgetRef` or `ProviderContainer`. It excels at composing asynchronous data sources.

## Getting Started

1.  Clone this repository.
2.  Run `flutter pub get` to install dependencies.
3.  Run `flutter run` to launch the application.

## Testing

This repository includes focused tests covering the core behavior (initial states, async loading, error handling, and state toggling) of each state management implementation.

To run the tests:
```bash
flutter test
```

## Out of Scope

This is a technical showcase focused strictly on comparing state management tools. The following are intentionally omitted to keep the comparison clear:
*   Persistent storage (uses in-memory mock data)
*   Networking / API calls
*   Complex UI / Animations
*   Authentication
