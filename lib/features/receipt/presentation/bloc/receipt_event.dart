import 'package:equatable/equatable.dart';
import '../../domain/entities/receipt.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object> get props => [];
}

class LoadAllReceipts extends ReceiptEvent {}

class LoadReceiptById extends ReceiptEvent {
  final String id;

  const LoadReceiptById(this.id);

  @override
  List<Object> get props => [id];
}

class CreateNewReceipt extends ReceiptEvent {
  final Receipt receipt;

  const CreateNewReceipt(this.receipt);

  @override
  List<Object> get props => [receipt];
}

class DeleteReceiptById extends ReceiptEvent {
  final String id;

  const DeleteReceiptById(this.id);

  @override
  List<Object> get props => [id];
}
