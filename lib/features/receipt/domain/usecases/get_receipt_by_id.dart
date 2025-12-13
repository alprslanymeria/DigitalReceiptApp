import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/receipt.dart';
import '../repositories/receipt_repository.dart';

class GetReceiptById implements UseCase<Receipt, GetReceiptByIdParams> {
  final ReceiptRepository repository;

  GetReceiptById(this.repository);

  @override
  Future<Either<Failure, Receipt>> call(GetReceiptByIdParams params) async {
    return await repository.getReceiptById(params.id);
  }
}

class GetReceiptByIdParams extends Equatable {
  final String id;

  const GetReceiptByIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
