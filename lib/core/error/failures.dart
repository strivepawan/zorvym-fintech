sealed class Failure {
  final String message;
  const Failure(this.message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Local storage error']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message) : super(message);
}
