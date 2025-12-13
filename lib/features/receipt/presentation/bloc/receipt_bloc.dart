import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_receipt.dart';
import '../../domain/usecases/delete_receipt.dart';
import '../../domain/usecases/get_all_receipts.dart';
import '../../domain/usecases/get_receipt_by_id.dart';
import 'receipt_event.dart';
import 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final GetAllReceipts getAllReceipts;
  final GetReceiptById getReceiptById;
  final CreateReceipt createReceipt;
  final DeleteReceipt deleteReceipt;

  ReceiptBloc({
    required this.getAllReceipts,
    required this.getReceiptById,
    required this.createReceipt,
    required this.deleteReceipt,
  }) : super(ReceiptInitial()) {
    on<LoadAllReceipts>(_onLoadAllReceipts);
    on<LoadReceiptById>(_onLoadReceiptById);
    on<CreateNewReceipt>(_onCreateNewReceipt);
    on<DeleteReceiptById>(_onDeleteReceiptById);
  }

  Future<void> _onLoadAllReceipts(
    LoadAllReceipts event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(ReceiptLoading());
    final result = await getAllReceipts(NoParams());
    result.fold(
      (failure) => emit(ReceiptError(failure.message)),
      (receipts) => emit(ReceiptsLoaded(receipts)),
    );
  }

  Future<void> _onLoadReceiptById(
    LoadReceiptById event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(ReceiptLoading());
    final result = await getReceiptById(GetReceiptByIdParams(id: event.id));
    result.fold(
      (failure) => emit(ReceiptError(failure.message)),
      (receipt) => emit(ReceiptLoaded(receipt)),
    );
  }

  Future<void> _onCreateNewReceipt(
    CreateNewReceipt event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(ReceiptLoading());
    final result =
        await createReceipt(CreateReceiptParams(receipt: event.receipt));
    result.fold(
      (failure) => emit(ReceiptError(failure.message)),
      (receipt) => emit(ReceiptCreated(receipt)),
    );
  }

  Future<void> _onDeleteReceiptById(
    DeleteReceiptById event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(ReceiptLoading());
    final result = await deleteReceipt(DeleteReceiptParams(id: event.id));
    result.fold(
      (failure) => emit(ReceiptError(failure.message)),
      (_) => emit(ReceiptDeleted()),
    );
  }
}
