import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digital_receipt_app/core/usecases/usecase.dart';
import 'package:digital_receipt_app/features/receipt/domain/usecases/add_receipt.dart';
import 'package:digital_receipt_app/features/receipt/domain/usecases/delete_receipt.dart';
import 'package:digital_receipt_app/features/receipt/domain/usecases/get_receipts.dart';
import 'package:digital_receipt_app/features/receipt/presentation/bloc/receipt_event.dart';
import 'package:digital_receipt_app/features/receipt/presentation/bloc/receipt_state.dart';

/// Receipt BLoC
/// Follows Single Responsibility Principle - manages receipt state
/// Depends on use cases (Dependency Inversion Principle)
class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final GetReceipts getReceipts;
  final AddReceipt addReceipt;
  final DeleteReceipt deleteReceipt;

  ReceiptBloc({
    required this.getReceipts,
    required this.addReceipt,
    required this.deleteReceipt,
  }) : super(const ReceiptInitial()) {
    on<LoadReceiptsEvent>(_onLoadReceipts);
    on<AddReceiptEvent>(_onAddReceipt);
    on<DeleteReceiptEvent>(_onDeleteReceipt);
  }

  Future<void> _onLoadReceipts(
    LoadReceiptsEvent event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(const ReceiptLoading());
    final result = await getReceipts(const NoParams());
    result.fold(
      (failure) => emit(ReceiptError(failure.message)),
      (receipts) => emit(ReceiptLoaded(receipts)),
    );
  }

  Future<void> _onAddReceipt(
    AddReceiptEvent event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(const ReceiptLoading());
    final result = await addReceipt(AddReceiptParams(receipt: event.receipt));
    result.fold(
      (failure) => emit(ReceiptError(failure.message)),
      (_) {
        emit(const ReceiptOperationSuccess('Receipt added successfully'));
        add(const LoadReceiptsEvent());
      },
    );
  }

  Future<void> _onDeleteReceipt(
    DeleteReceiptEvent event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(const ReceiptLoading());
    final result = await deleteReceipt(DeleteReceiptParams(id: event.receiptId));
    result.fold(
      (failure) => emit(ReceiptError(failure.message)),
      (_) {
        emit(const ReceiptOperationSuccess('Receipt deleted successfully'));
        add(const LoadReceiptsEvent());
      },
    );
  }
}
