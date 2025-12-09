import 'package:dartz/dartz.dart';
import 'package:digital_receipt_app/core/error/exceptions.dart';
import 'package:digital_receipt_app/core/error/failures.dart';
import 'package:digital_receipt_app/core/utils/network_info.dart';
import 'package:digital_receipt_app/features/receipt/data/datasources/receipt_local_data_source.dart';
import 'package:digital_receipt_app/features/receipt/data/datasources/receipt_remote_data_source.dart';
import 'package:digital_receipt_app/features/receipt/data/models/receipt_model.dart';
import 'package:digital_receipt_app/features/receipt/domain/entities/receipt.dart';
import 'package:digital_receipt_app/features/receipt/domain/repositories/receipt_repository.dart';

/// Receipt Repository Implementation
/// Follows Dependency Inversion Principle - depends on abstractions
/// Implements the repository interface from domain layer
class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptRemoteDataSource remoteDataSource;
  final ReceiptLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ReceiptRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Receipt>>> getReceipts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteReceipts = await remoteDataSource.getReceipts();
        await localDataSource.cacheReceipts(remoteReceipts);
        return Right(remoteReceipts);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      try {
        final localReceipts = await localDataSource.getCachedReceipts();
        return Right(localReceipts);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Receipt>> getReceiptById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final receipt = await remoteDataSource.getReceiptById(id);
        await localDataSource.cacheReceipt(receipt);
        return Right(receipt);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      try {
        final receipt = await localDataSource.getCachedReceiptById(id);
        if (receipt != null) {
          return Right(receipt);
        } else {
          return const Left(CacheFailure('Receipt not found in cache'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Receipt>> addReceipt(Receipt receipt) async {
    try {
      final receiptModel = ReceiptModel.fromEntity(receipt);
      if (await networkInfo.isConnected) {
        final addedReceipt = await remoteDataSource.addReceipt(receiptModel);
        await localDataSource.cacheReceipt(addedReceipt);
        return Right(addedReceipt);
      } else {
        // Save locally when offline
        await localDataSource.cacheReceipt(receiptModel);
        return Right(receiptModel);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Receipt>> updateReceipt(Receipt receipt) async {
    try {
      final receiptModel = ReceiptModel.fromEntity(receipt);
      if (await networkInfo.isConnected) {
        final updatedReceipt = await remoteDataSource.updateReceipt(receiptModel);
        await localDataSource.cacheReceipt(updatedReceipt);
        return Right(updatedReceipt);
      } else {
        await localDataSource.cacheReceipt(receiptModel);
        return Right(receiptModel);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReceipt(String id) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.deleteReceipt(id);
      }
      await localDataSource.deleteCachedReceipt(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Receipt>>> searchReceipts(String query) async {
    try {
      final receipts = await localDataSource.getCachedReceipts();
      final filteredReceipts = receipts
          .where((receipt) =>
              receipt.storeName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return Right(filteredReceipts);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Receipt>>> getReceiptsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final receipts = await localDataSource.getCachedReceipts();
      final filteredReceipts = receipts
          .where((receipt) =>
              receipt.date.isAfter(startDate) && receipt.date.isBefore(endDate))
          .toList();
      return Right(filteredReceipts);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
