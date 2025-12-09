/// Constants used throughout the application
class AppConstants {
  // API
  static const String baseUrl = 'https://api.example.com';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Cache
  static const String cacheKey = 'CACHED_DATA';
  static const int cacheExpirationHours = 24;

  // Database
  static const String databaseName = 'digital_receipt.db';
  static const int databaseVersion = 1;

  // Error messages
  static const String serverErrorMessage = 'Server error occurred';
  static const String cacheErrorMessage = 'Cache error occurred';
  static const String networkErrorMessage = 'No internet connection';
  static const String unexpectedErrorMessage = 'Unexpected error occurred';
}
