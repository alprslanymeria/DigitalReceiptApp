import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/receipt.dart';
import '../../domain/repositories/receipt_repository.dart';
import '../datasources/receipt_local_data_source.dart';
import '../datasources/receipt_remote_data_source.dart';
import '../models/receipt_model.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptRemoteDataSource remoteDataSource;
  final ReceiptLocalDataSource localDataSource;

  ReceiptRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Receipt>>> getAllReceipts() async {
    try {
      final remoteReceipts = await remoteDataSource.getAllReceipts();
      await localDataSource.cacheReceipts(remoteReceipts);
      return Right(remoteReceipts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      try {
        final cachedReceipts = await localDataSource.getCachedReceipts();
        return Right(cachedReceipts);
      } on CacheException catch (cacheError) {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Receipt>> getReceiptById(String id) async {
    try {
      final receipt = await remoteDataSource.getReceiptById(id);
      await localDataSource.cacheReceipt(receipt);
      return Right(receipt);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      try {
        final cachedReceipt = await localDataSource.getCachedReceiptById(id);
        return Right(cachedReceipt);
      } on CacheException catch (cacheError) {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Receipt>> createReceipt(Receipt receipt) async {
    try {
      final receiptModel = ReceiptModel.fromEntity(receipt);
      final createdReceipt = await remoteDataSource.createReceipt(receiptModel);
      await localDataSource.cacheReceipt(createdReceipt);
      return Right(createdReceipt);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Receipt>> updateReceipt(Receipt receipt) async {
    try {
      final receiptModel = ReceiptModel.fromEntity(receipt);
      final updatedReceipt = await remoteDataSource.updateReceipt(receiptModel);
      await localDataSource.cacheReceipt(updatedReceipt);
      return Right(updatedReceipt);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReceipt(String id) async {
    try {
      await remoteDataSource.deleteReceipt(id);
      await localDataSource.deleteReceipt(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
