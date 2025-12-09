import 'package:dartz/dartz.dart';
import 'package:digital_receipt_app/core/usecases/usecase.dart';
import 'package:digital_receipt_app/features/receipt/domain/entities/receipt.dart';
import 'package:digital_receipt_app/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:digital_receipt_app/features/receipt/domain/usecases/get_receipts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_receipts_test.mocks.dart';

@GenerateMocks([ReceiptRepository])
void main() {
  late GetReceipts usecase;
  late MockReceiptRepository mockReceiptRepository;

  setUp(() {
    mockReceiptRepository = MockReceiptRepository();
    usecase = GetReceipts(mockReceiptRepository);
  });

  final tReceipts = [
    Receipt(
      id: '1',
      storeName: 'Test Store',
      date: DateTime.now(),
      totalAmount: 100.0,
      items: const [],
    ),
  ];

  test('should get receipts from the repository', () async {
    // Arrange
    when(mockReceiptRepository.getReceipts())
        .thenAnswer((_) async => Right(tReceipts));

    // Act
    final result = await usecase(const NoParams());

    // Assert
    expect(result, Right(tReceipts));
    verify(mockReceiptRepository.getReceipts());
    verifyNoMoreInteractions(mockReceiptRepository);
  });
}
