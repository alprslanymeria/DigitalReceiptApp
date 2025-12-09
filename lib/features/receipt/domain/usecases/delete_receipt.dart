import 'package:dartz/dartz.dart';
import 'package:digital_receipt_app/core/error/failures.dart';
import 'package:digital_receipt_app/core/usecases/usecase.dart';
import 'package:digital_receipt_app/features/receipt/domain/repositories/receipt_repository.dart';

/// Delete Receipt Use Case
/// Follows Single Responsibility Principle
class DeleteReceipt implements UseCase<void, DeleteReceiptParams> {
  final ReceiptRepository repository;

  DeleteReceipt(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteReceiptParams params) async {
    return await repository.deleteReceipt(params.id);
  }
}

class DeleteReceiptParams {
  final String id;

  const DeleteReceiptParams({required this.id});
}
