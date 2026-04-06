class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Local storage exception']);
}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);
}
