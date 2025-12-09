/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Server exceptions
class ServerException extends AppException {
  const ServerException(super.message, [super.code]);
}

/// Cache exceptions
class CacheException extends AppException {
  const CacheException(super.message, [super.code]);
}

/// Network exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);
}
