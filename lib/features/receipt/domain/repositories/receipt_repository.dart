import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/receipt.dart';

abstract class ReceiptRepository {
  Future<Either<Failure, List<Receipt>>> getAllReceipts();
  Future<Either<Failure, Receipt>> getReceiptById(String id);
  Future<Either<Failure, Receipt>> createReceipt(Receipt receipt);
  Future<Either<Failure, Receipt>> updateReceipt(Receipt receipt);
  Future<Either<Failure, void>> deleteReceipt(String id);
}
