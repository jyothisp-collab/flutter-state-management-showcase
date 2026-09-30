import 'package:equatable/equatable.dart';

/// Base class for application errors.
sealed class AppError extends Equatable {
  const AppError();

  String get message;
}

/// A network-related error.
final class NetworkError extends AppError {
  const NetworkError(this.originalException);

  @override
  final Exception originalException;

  @override
  String get message =>
      'Network error: ${originalException.toString()}';

  @override
  List<Object?> get props => [originalException];
}

/// An unknown or unexpected error.
final class UnknownError extends AppError {
  const UnknownError(this.originalException);

  @override
  final Exception originalException;

  @override
  String get message =>
      'Unexpected error: ${originalException.toString()}';

  @override
  List<Object?> get props => [originalException];
}
