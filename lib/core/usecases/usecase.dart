import 'package:dartz/dartz.dart';
import 'package:digital_receipt_app/core/error/failures.dart';

/// Base class for all use cases
/// Follows the Single Responsibility Principle and Interface Segregation Principle
/// Type: Return type, Params: Parameters type
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// For use cases that don't require parameters
class NoParams {
  const NoParams();
}
