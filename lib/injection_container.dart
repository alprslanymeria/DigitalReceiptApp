import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_receipt_app/core/utils/network_info.dart';
import 'package:digital_receipt_app/features/receipt/data/datasources/receipt_local_data_source.dart';
import 'package:digital_receipt_app/features/receipt/data/datasources/receipt_remote_data_source.dart';
import 'package:digital_receipt_app/features/receipt/data/repositories/receipt_repository_impl.dart';
import 'package:digital_receipt_app/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:digital_receipt_app/features/receipt/domain/usecases/add_receipt.dart';
import 'package:digital_receipt_app/features/receipt/domain/usecases/delete_receipt.dart';
import 'package:digital_receipt_app/features/receipt/domain/usecases/get_receipts.dart';
import 'package:digital_receipt_app/features/receipt/presentation/bloc/receipt_bloc.dart';

/// Service Locator for Dependency Injection
/// Follows Dependency Inversion Principle
/// Uses get_it package for service location
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Receipt
  // Bloc
  sl.registerFactory(
    () => ReceiptBloc(
      getReceipts: sl(),
      addReceipt: sl(),
      deleteReceipt: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetReceipts(sl()));
  sl.registerLazySingleton(() => AddReceipt(sl()));
  sl.registerLazySingleton(() => DeleteReceipt(sl()));

  // Repository
  sl.registerLazySingleton<ReceiptRepository>(
    () => ReceiptRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ReceiptRemoteDataSource>(
    () => ReceiptRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ReceiptLocalDataSource>(
    () => ReceiptLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());
}
