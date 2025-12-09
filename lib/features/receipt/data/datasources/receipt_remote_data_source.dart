import 'package:digital_receipt_app/features/receipt/data/models/receipt_model.dart';

/// Receipt Remote Data Source Interface
/// Follows Interface Segregation Principle
abstract class ReceiptRemoteDataSource {
  /// Fetch receipts from API
  Future<List<ReceiptModel>> getReceipts();

  /// Fetch a single receipt from API
  Future<ReceiptModel> getReceiptById(String id);

  /// Post a new receipt to API
  Future<ReceiptModel> addReceipt(ReceiptModel receipt);

  /// Update a receipt on API
  Future<ReceiptModel> updateReceipt(ReceiptModel receipt);

  /// Delete a receipt from API
  Future<void> deleteReceipt(String id);
}

/// Implementation of Remote Data Source
class ReceiptRemoteDataSourceImpl implements ReceiptRemoteDataSource {
  // In a real app, you would inject Dio client here
  // final Dio client;
  // ReceiptRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ReceiptModel>> getReceipts() async {
    // TODO: Implement API call
    // Example:
    // final response = await client.get('/receipts');
    // return (response.data as List)
    //     .map((json) => ReceiptModel.fromJson(json))
    //     .toList();
    throw UnimplementedError('API integration pending');
  }

  @override
  Future<ReceiptModel> getReceiptById(String id) async {
    // TODO: Implement API call
    throw UnimplementedError('API integration pending');
  }

  @override
  Future<ReceiptModel> addReceipt(ReceiptModel receipt) async {
    // TODO: Implement API call
    throw UnimplementedError('API integration pending');
  }

  @override
  Future<ReceiptModel> updateReceipt(ReceiptModel receipt) async {
    // TODO: Implement API call
    throw UnimplementedError('API integration pending');
  }

  @override
  Future<void> deleteReceipt(String id) async {
    // TODO: Implement API call
    throw UnimplementedError('API integration pending');
  }
}
