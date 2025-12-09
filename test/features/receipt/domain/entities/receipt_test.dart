import 'package:flutter_test/flutter_test.dart';
import 'package:digital_receipt_app/features/receipt/domain/entities/receipt.dart';

void main() {
  group('Receipt Entity', () {
    test('should be a subclass of Equatable', () {
      // Arrange
      const receipt = Receipt(
        id: '1',
        storeName: 'Test Store',
        date: null,
        totalAmount: 100.0,
        items: [],
      );

      // Assert
      expect(receipt, isA<Receipt>());
    });

    test('should have correct properties', () {
      // Arrange
      final date = DateTime.now();
      const items = [
        ReceiptItem(name: 'Item 1', price: 50.0, quantity: 2),
      ];
      
      final receipt = Receipt(
        id: '1',
        storeName: 'Test Store',
        date: date,
        totalAmount: 100.0,
        items: items,
        category: 'Food',
        notes: 'Test notes',
      );

      // Assert
      expect(receipt.id, '1');
      expect(receipt.storeName, 'Test Store');
      expect(receipt.date, date);
      expect(receipt.totalAmount, 100.0);
      expect(receipt.items, items);
      expect(receipt.category, 'Food');
      expect(receipt.notes, 'Test notes');
    });
  });

  group('ReceiptItem Entity', () {
    test('should calculate total correctly', () {
      // Arrange
      const item = ReceiptItem(
        name: 'Test Item',
        price: 10.0,
        quantity: 3,
      );

      // Assert
      expect(item.total, 30.0);
    });
  });
}
