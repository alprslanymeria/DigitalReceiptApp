import 'package:equatable/equatable.dart';
import '../../domain/entities/receipt.dart';

abstract class ReceiptState extends Equatable {
  const ReceiptState();

  @override
  List<Object> get props => [];
}

class ReceiptInitial extends ReceiptState {}

class ReceiptLoading extends ReceiptState {}

class ReceiptsLoaded extends ReceiptState {
  final List<Receipt> receipts;

  const ReceiptsLoaded(this.receipts);

  @override
  List<Object> get props => [receipts];
}

class ReceiptLoaded extends ReceiptState {
  final Receipt receipt;

  const ReceiptLoaded(this.receipt);

  @override
  List<Object> get props => [receipt];
}

class ReceiptError extends ReceiptState {
  final String message;

  const ReceiptError(this.message);

  @override
  List<Object> get props => [message];
}

class ReceiptCreated extends ReceiptState {
  final Receipt receipt;

  const ReceiptCreated(this.receipt);

  @override
  List<Object> get props => [receipt];
}

class ReceiptDeleted extends ReceiptState {}
