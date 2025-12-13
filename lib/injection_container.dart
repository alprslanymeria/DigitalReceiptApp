import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/receipt/data/datasources/receipt_local_data_source.dart';
import 'features/receipt/data/datasources/receipt_remote_data_source.dart';
import 'features/receipt/data/repositories/receipt_repository_impl.dart';
import 'features/receipt/domain/repositories/receipt_repository.dart';
import 'features/receipt/domain/usecases/create_receipt.dart';
import 'features/receipt/domain/usecases/delete_receipt.dart';
import 'features/receipt/domain/usecases/get_all_receipts.dart';
import 'features/receipt/domain/usecases/get_receipt_by_id.dart';
import 'features/receipt/presentation/bloc/receipt_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Receipt
  // Bloc
  sl.registerFactory(
    () => ReceiptBloc(
      getAllReceipts: sl(),
      getReceiptById: sl(),
      createReceipt: sl(),
      deleteReceipt: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllReceipts(sl()));
  sl.registerLazySingleton(() => GetReceiptById(sl()));
  sl.registerLazySingleton(() => CreateReceipt(sl()));
  sl.registerLazySingleton(() => DeleteReceipt(sl()));

  // Repository
  sl.registerLazySingleton<ReceiptRepository>(
    () => ReceiptRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
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

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
