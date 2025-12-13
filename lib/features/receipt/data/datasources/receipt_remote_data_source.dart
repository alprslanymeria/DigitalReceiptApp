import '../models/receipt_model.dart';

abstract class ReceiptRemoteDataSource {
  Future<List<ReceiptModel>> getAllReceipts();
  Future<ReceiptModel> getReceiptById(String id);
  Future<ReceiptModel> createReceipt(ReceiptModel receipt);
  Future<ReceiptModel> updateReceipt(ReceiptModel receipt);
  Future<void> deleteReceipt(String id);
}

class ReceiptRemoteDataSourceImpl implements ReceiptRemoteDataSource {
  // In a real app, this would use http client
  // For now, implementing with mock data

  @override
  Future<List<ReceiptModel>> getAllReceipts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Return mock data or call API
    return [];
  }

  @override
  Future<ReceiptModel> getReceiptById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, this would make an API call
    // For now, return empty list from getAllReceipts or throw specific exception
    final receipts = await getAllReceipts();
    final receipt = receipts.where((r) => r.id == id).firstOrNull;
    if (receipt == null) {
      throw Exception('Receipt with id $id not found');
    }
    return receipt;
  }

  @override
  Future<ReceiptModel> createReceipt(ReceiptModel receipt) async {
    await Future.delayed(const Duration(seconds: 1));
    return receipt;
  }

  @override
  Future<ReceiptModel> updateReceipt(ReceiptModel receipt) async {
    await Future.delayed(const Duration(seconds: 1));
    return receipt;
  }

  @override
  Future<void> deleteReceipt(String id) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
