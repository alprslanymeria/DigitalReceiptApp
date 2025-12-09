import 'package:flutter/material.dart';
import 'package:digital_receipt_app/features/receipt/domain/entities/receipt.dart';
import 'package:intl/intl.dart';

/// Receipt List Item Widget
/// Displays a single receipt in the list
class ReceiptListItem extends StatelessWidget {
  final Receipt receipt;

  const ReceiptListItem({
    super.key,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            receipt.storeName[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          receipt.storeName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          dateFormat.format(receipt.date),
        ),
        trailing: Text(
          '\$${receipt.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        onTap: () {
          // TODO: Navigate to receipt detail page
        },
      ),
    );
  }
}
