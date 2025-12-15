/// A type that represents either success or failure.
sealed class Result<T, E> {
  const Result();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T? get valueOrNull => switch (this) {
    Success(value: final v) => v,
    Failure() => null,
  };

  E? get errorOrNull => switch (this) {
    Success() => null,
    Failure(error: final e) => e,
  };

  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  }) => switch (this) {
    Success(value: final v) => success(v),
    Failure(error: final e) => failure(e),
  };
}

final class Success<T, E> extends Result<T, E> {
  const Success(this.value);
  final T value;
}

final class Failure<T, E> extends Result<T, E> {
  const Failure(this.error);
  final E error;
}
