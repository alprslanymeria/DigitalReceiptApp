import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/receipt.dart';
import '../repositories/receipt_repository.dart';

class CreateReceipt implements UseCase<Receipt, CreateReceiptParams> {
  final ReceiptRepository repository;

  CreateReceipt(this.repository);

  @override
  Future<Either<Failure, Receipt>> call(CreateReceiptParams params) async {
    return await repository.createReceipt(params.receipt);
  }
}

class CreateReceiptParams extends Equatable {
  final Receipt receipt;

  const CreateReceiptParams({required this.receipt});

  @override
  List<Object> get props => [receipt];
}
