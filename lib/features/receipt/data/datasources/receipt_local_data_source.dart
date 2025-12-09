import 'package:digital_receipt_app/features/receipt/data/models/receipt_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Receipt Local Data Source Interface
/// Follows Interface Segregation Principle
abstract class ReceiptLocalDataSource {
  /// Get cached receipts
  Future<List<ReceiptModel>> getCachedReceipts();

  /// Cache receipts
  Future<void> cacheReceipts(List<ReceiptModel> receipts);

  /// Get a single cached receipt
  Future<ReceiptModel?> getCachedReceiptById(String id);

  /// Cache a single receipt
  Future<void> cacheReceipt(ReceiptModel receipt);

  /// Delete cached receipt
  Future<void> deleteCachedReceipt(String id);
}

/// Implementation of Local Data Source using SharedPreferences
class ReceiptLocalDataSourceImpl implements ReceiptLocalDataSource {
  final SharedPreferences sharedPreferences;

  ReceiptLocalDataSourceImpl({required this.sharedPreferences});

  static const String cachedReceiptsKey = 'CACHED_RECEIPTS';

  @override
  Future<List<ReceiptModel>> getCachedReceipts() async {
    final jsonString = sharedPreferences.getString(cachedReceiptsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ReceiptModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> cacheReceipts(List<ReceiptModel> receipts) async {
    final jsonList = receipts.map((receipt) => receipt.toJson()).toList();
    await sharedPreferences.setString(
      cachedReceiptsKey,
      json.encode(jsonList),
    );
  }

  @override
  Future<ReceiptModel?> getCachedReceiptById(String id) async {
    final receipts = await getCachedReceipts();
    try {
      return receipts.firstWhere((receipt) => receipt.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheReceipt(ReceiptModel receipt) async {
    final receipts = await getCachedReceipts();
    final index = receipts.indexWhere((r) => r.id == receipt.id);
    if (index != -1) {
      receipts[index] = receipt;
    } else {
      receipts.add(receipt);
    }
    await cacheReceipts(receipts);
  }

  @override
  Future<void> deleteCachedReceipt(String id) async {
    final receipts = await getCachedReceipts();
    receipts.removeWhere((receipt) => receipt.id == id);
    await cacheReceipts(receipts);
  }
}
