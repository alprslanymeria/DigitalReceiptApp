import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digital_receipt_app/features/receipt/presentation/bloc/receipt_bloc.dart';
import 'package:digital_receipt_app/features/receipt/presentation/bloc/receipt_event.dart';
import 'package:digital_receipt_app/features/receipt/presentation/bloc/receipt_state.dart';
import 'package:digital_receipt_app/features/receipt/presentation/widgets/receipt_list_item.dart';

/// Receipts List Page
/// Displays all receipts
class ReceiptsPage extends StatelessWidget {
  const ReceiptsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Receipts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: BlocBuilder<ReceiptBloc, ReceiptState>(
        builder: (context, state) {
          if (state is ReceiptInitial) {
            context.read<ReceiptBloc>().add(const LoadReceiptsEvent());
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReceiptLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReceiptLoaded) {
            if (state.receipts.isEmpty) {
              return const Center(
                child: Text('No receipts found'),
              );
            }
            return ListView.builder(
              itemCount: state.receipts.length,
              itemBuilder: (context, index) {
                return ReceiptListItem(receipt: state.receipts[index]);
              },
            );
          } else if (state is ReceiptError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReceiptBloc>().add(const LoadReceiptsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add receipt page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
