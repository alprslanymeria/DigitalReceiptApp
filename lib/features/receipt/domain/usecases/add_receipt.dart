import 'package:dartz/dartz.dart';
import 'package:digital_receipt_app/core/error/failures.dart';
import 'package:digital_receipt_app/core/usecases/usecase.dart';
import 'package:digital_receipt_app/features/receipt/domain/entities/receipt.dart';
import 'package:digital_receipt_app/features/receipt/domain/repositories/receipt_repository.dart';

/// Add Receipt Use Case
/// Follows Single Responsibility Principle
class AddReceipt implements UseCase<Receipt, AddReceiptParams> {
  final ReceiptRepository repository;

  AddReceipt(this.repository);

  @override
  Future<Either<Failure, Receipt>> call(AddReceiptParams params) async {
    return await repository.addReceipt(params.receipt);
  }
}

class AddReceiptParams {
  final Receipt receipt;

  const AddReceiptParams({required this.receipt});
}
