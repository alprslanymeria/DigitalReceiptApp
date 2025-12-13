import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/receipt.dart';

class ReceiptListItem extends StatelessWidget {
  final Receipt receipt;
  final VoidCallback onTap;

  const ReceiptListItem({
    super.key,
    required this.receipt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.receipt_long),
        ),
        title: Text(
          receipt.storeName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(receipt.storeAddress),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(receipt.date),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Text(
          '\$${receipt.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        isThreeLine: true,
        onTap: onTap,
      ),
    );
  }
}
