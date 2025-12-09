import 'package:dartz/dartz.dart';
import 'package:digital_receipt_app/core/error/failures.dart';
import 'package:digital_receipt_app/core/usecases/usecase.dart';
import 'package:digital_receipt_app/features/receipt/domain/entities/receipt.dart';
import 'package:digital_receipt_app/features/receipt/domain/repositories/receipt_repository.dart';

/// Get Receipts Use Case
/// Follows Single Responsibility Principle - only responsible for getting receipts
class GetReceipts implements UseCase<List<Receipt>, NoParams> {
  final ReceiptRepository repository;

  GetReceipts(this.repository);

  @override
  Future<Either<Failure, List<Receipt>>> call(NoParams params) async {
    return await repository.getReceipts();
  }
}
