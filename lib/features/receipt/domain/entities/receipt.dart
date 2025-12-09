import 'package:equatable/equatable.dart';

/// Receipt Entity - Domain layer
/// Pure business logic, no dependencies on external frameworks
/// Follows Single Responsibility Principle
class Receipt extends Equatable {
  final String id;
  final String storeName;
  final DateTime date;
  final double totalAmount;
  final List<ReceiptItem> items;
  final String? category;
  final String? notes;

  const Receipt({
    required this.id,
    required this.storeName,
    required this.date,
    required this.totalAmount,
    required this.items,
    this.category,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        storeName,
        date,
        totalAmount,
        items,
        category,
        notes,
      ];
}

/// Receipt Item Entity
class ReceiptItem extends Equatable {
  final String name;
  final double price;
  final int quantity;

  const ReceiptItem({
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;

  @override
  List<Object> get props => [name, price, quantity];
}
