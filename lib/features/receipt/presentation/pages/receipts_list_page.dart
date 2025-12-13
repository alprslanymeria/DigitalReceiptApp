import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/receipt_bloc.dart';
import '../bloc/receipt_event.dart';
import '../bloc/receipt_state.dart';
import '../widgets/receipt_list_item.dart';
import 'receipt_detail_page.dart';

class ReceiptsListPage extends StatelessWidget {
  const ReceiptsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReceiptBloc>()..add(LoadAllReceipts()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Digital Receipts'),
          elevation: 2,
        ),
        body: BlocBuilder<ReceiptBloc, ReceiptState>(
          builder: (context, state) {
            if (state is ReceiptLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReceiptsLoaded) {
              if (state.receipts.isEmpty) {
                return const Center(
                  child: Text('No receipts found'),
                );
              }
              return ListView.builder(
                itemCount: state.receipts.length,
                itemBuilder: (context, index) {
                  final receipt = state.receipts[index];
                  return ReceiptListItem(
                    receipt: receipt,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReceiptDetailPage(
                            receiptId: receipt.id,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is ReceiptError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message),
                  ],
                ),
              );
            }
            return const Center(child: Text('Welcome to Digital Receipts'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to create receipt page
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
