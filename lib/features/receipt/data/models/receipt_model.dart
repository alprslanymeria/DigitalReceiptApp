import 'package:digital_receipt_app/features/receipt/domain/entities/receipt.dart';

/// Receipt Model - Data layer
/// Extends entity and adds JSON serialization
/// Follows Liskov Substitution Principle (LSP)
class ReceiptModel extends Receipt {
  const ReceiptModel({
    required super.id,
    required super.storeName,
    required super.date,
    required super.totalAmount,
    required super.items,
    super.category,
    super.notes,
  });

  /// Convert from JSON
  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      id: json['id'] as String,
      storeName: json['store_name'] as String,
      date: DateTime.parse(json['date'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((item) => ReceiptItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String?,
      notes: json['notes'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_name': storeName,
      'date': date.toIso8601String(),
      'total_amount': totalAmount,
      'items': items.map((item) => (item as ReceiptItemModel).toJson()).toList(),
      'category': category,
      'notes': notes,
    };
  }

  /// Convert from entity
  factory ReceiptModel.fromEntity(Receipt receipt) {
    return ReceiptModel(
      id: receipt.id,
      storeName: receipt.storeName,
      date: receipt.date,
      totalAmount: receipt.totalAmount,
      items: receipt.items,
      category: receipt.category,
      notes: receipt.notes,
    );
  }
}

/// Receipt Item Model
class ReceiptItemModel extends ReceiptItem {
  const ReceiptItemModel({
    required super.name,
    required super.price,
    required super.quantity,
  });

  factory ReceiptItemModel.fromJson(Map<String, dynamic> json) {
    return ReceiptItemModel(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
