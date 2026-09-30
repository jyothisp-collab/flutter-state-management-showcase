/// A sealed class representing the outcome of an operation.
///
/// [Result] is used throughout the data layer to wrap repository calls,
/// providing a type-safe way to handle both success and failure cases.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}

/// A successful result containing a [value].
final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

/// A failed result containing an [error].
final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppError error;
}
