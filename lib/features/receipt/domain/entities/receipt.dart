import 'package:equatable/equatable.dart';

class Receipt extends Equatable {
  final String id;
  final String storeName;
  final String storeAddress;
  final DateTime date;
  final double totalAmount;
  final List<ReceiptItem> items;
  final String? imageUrl;

  const Receipt({
    required this.id,
    required this.storeName,
    required this.storeAddress,
    required this.date,
    required this.totalAmount,
    required this.items,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        storeName,
        storeAddress,
        date,
        totalAmount,
        items,
        imageUrl,
      ];
}

class ReceiptItem extends Equatable {
  final String name;
  final int quantity;
  final double price;
  final double totalPrice;

  const ReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  @override
  List<Object> get props => [name, quantity, price, totalPrice];
}
