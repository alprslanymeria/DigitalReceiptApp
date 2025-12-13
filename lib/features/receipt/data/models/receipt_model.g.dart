// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptModel _$ReceiptModelFromJson(Map<String, dynamic> json) => ReceiptModel(
      id: json['id'] as String,
      storeName: json['storeName'] as String,
      storeAddress: json['storeAddress'] as String,
      date: DateTime.parse(json['date'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((e) => ReceiptItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$ReceiptModelToJson(ReceiptModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeName': instance.storeName,
      'storeAddress': instance.storeAddress,
      'date': instance.date.toIso8601String(),
      'totalAmount': instance.totalAmount,
      'items': instance.items.map((e) => (e as ReceiptItemModel).toJson()).toList(),
      'imageUrl': instance.imageUrl,
    };

ReceiptItemModel _$ReceiptItemModelFromJson(Map<String, dynamic> json) =>
    ReceiptItemModel(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$ReceiptItemModelToJson(ReceiptItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'price': instance.price,
      'totalPrice': instance.totalPrice,
    };
