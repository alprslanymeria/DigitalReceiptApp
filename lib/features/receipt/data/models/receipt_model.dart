import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/receipt.dart';

part 'receipt_model.g.dart';

@JsonSerializable()
class ReceiptModel extends Receipt {
  const ReceiptModel({
    required super.id,
    required super.storeName,
    required super.storeAddress,
    required super.date,
    required super.totalAmount,
    required super.items,
    super.imageUrl,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) =>
      _$ReceiptModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptModelToJson(this);

  factory ReceiptModel.fromEntity(Receipt receipt) {
    return ReceiptModel(
      id: receipt.id,
      storeName: receipt.storeName,
      storeAddress: receipt.storeAddress,
      date: receipt.date,
      totalAmount: receipt.totalAmount,
      items: receipt.items
          .map((item) => ReceiptItemModel.fromEntity(item))
          .toList(),
      imageUrl: receipt.imageUrl,
    );
  }
}

@JsonSerializable()
class ReceiptItemModel extends ReceiptItem {
  const ReceiptItemModel({
    required super.name,
    required super.quantity,
    required super.price,
    required super.totalPrice,
  });

  factory ReceiptItemModel.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptItemModelToJson(this);

  factory ReceiptItemModel.fromEntity(ReceiptItem item) {
    return ReceiptItemModel(
      name: item.name,
      quantity: item.quantity,
      price: item.price,
      totalPrice: item.totalPrice,
    );
  }
}
