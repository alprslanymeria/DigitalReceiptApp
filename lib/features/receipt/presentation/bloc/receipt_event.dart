import 'package:equatable/equatable.dart';
import 'package:digital_receipt_app/features/receipt/domain/entities/receipt.dart';

/// Receipt Events
abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object?> get props => [];
}

class LoadReceiptsEvent extends ReceiptEvent {
  const LoadReceiptsEvent();
}

class AddReceiptEvent extends ReceiptEvent {
  final Receipt receipt;

  const AddReceiptEvent(this.receipt);

  @override
  List<Object> get props => [receipt];
}

class DeleteReceiptEvent extends ReceiptEvent {
  final String receiptId;

  const DeleteReceiptEvent(this.receiptId);

  @override
  List<Object> get props => [receiptId];
}

class SearchReceiptsEvent extends ReceiptEvent {
  final String query;

  const SearchReceiptsEvent(this.query);

  @override
  List<Object> get props => [query];
}
