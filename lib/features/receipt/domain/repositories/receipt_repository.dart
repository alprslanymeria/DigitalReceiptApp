import 'package:dartz/dartz.dart';
import 'package:digital_receipt_app/core/error/failures.dart';
import 'package:digital_receipt_app/features/receipt/domain/entities/receipt.dart';

/// Receipt Repository Interface - Domain layer
/// Follows Dependency Inversion Principle (DIP) and Interface Segregation Principle (ISP)
/// Only defines what can be done, not how it's done
abstract class ReceiptRepository {
  /// Get all receipts
  Future<Either<Failure, List<Receipt>>> getReceipts();

  /// Get a single receipt by ID
  Future<Either<Failure, Receipt>> getReceiptById(String id);

  /// Add a new receipt
  Future<Either<Failure, Receipt>> addReceipt(Receipt receipt);

  /// Update an existing receipt
  Future<Either<Failure, Receipt>> updateReceipt(Receipt receipt);

  /// Delete a receipt
  Future<Either<Failure, void>> deleteReceipt(String id);

  /// Search receipts by store name
  Future<Either<Failure, List<Receipt>>> searchReceipts(String query);

  /// Get receipts by date range
  Future<Either<Failure, List<Receipt>>> getReceiptsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}
