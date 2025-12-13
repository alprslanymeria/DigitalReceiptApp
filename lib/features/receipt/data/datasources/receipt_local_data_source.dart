import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/receipt_model.dart';

abstract class ReceiptLocalDataSource {
  Future<List<ReceiptModel>> getCachedReceipts();
  Future<void> cacheReceipts(List<ReceiptModel> receipts);
  Future<ReceiptModel> getCachedReceiptById(String id);
  Future<void> cacheReceipt(ReceiptModel receipt);
  Future<void> deleteReceipt(String id);
}

const cachedReceiptsKey = 'CACHED_RECEIPTS';

class ReceiptLocalDataSourceImpl implements ReceiptLocalDataSource {
  final SharedPreferences sharedPreferences;

  ReceiptLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ReceiptModel>> getCachedReceipts() async {
    final jsonString = sharedPreferences.getString(cachedReceiptsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ReceiptModel.fromJson(json)).toList();
    } else {
      throw CacheException('No cached receipts found');
    }
  }

  @override
  Future<void> cacheReceipts(List<ReceiptModel> receipts) async {
    final jsonString =
        json.encode(receipts.map((receipt) => receipt.toJson()).toList());
    await sharedPreferences.setString(cachedReceiptsKey, jsonString);
  }

  @override
  Future<ReceiptModel> getCachedReceiptById(String id) async {
    final receipts = await getCachedReceipts();
    try {
      return receipts.firstWhere((receipt) => receipt.id == id);
    } catch (e) {
      throw CacheException('Receipt with id $id not found in cache');
    }
  }

  @override
  Future<void> cacheReceipt(ReceiptModel receipt) async {
    try {
      final receipts = await getCachedReceipts();
      final index = receipts.indexWhere((r) => r.id == receipt.id);
      if (index != -1) {
        receipts[index] = receipt;
      } else {
        receipts.add(receipt);
      }
      await cacheReceipts(receipts);
    } catch (e) {
      // If no cache exists, create new list
      await cacheReceipts([receipt]);
    }
  }

  @override
  Future<void> deleteReceipt(String id) async {
    final receipts = await getCachedReceipts();
    receipts.removeWhere((receipt) => receipt.id == id);
    await cacheReceipts(receipts);
  }
}
