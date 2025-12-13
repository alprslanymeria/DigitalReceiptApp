import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/receipt.dart';
import '../repositories/receipt_repository.dart';

class GetAllReceipts implements UseCase<List<Receipt>, NoParams> {
  final ReceiptRepository repository;

  GetAllReceipts(this.repository);

  @override
  Future<Either<Failure, List<Receipt>>> call(NoParams params) async {
    return await repository.getAllReceipts();
  }
}
