import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/receipt_bloc.dart';
import '../bloc/receipt_event.dart';
import '../bloc/receipt_state.dart';
import '../widgets/receipt_detail_widget.dart';

class ReceiptDetailPage extends StatelessWidget {
  final String receiptId;

  const ReceiptDetailPage({super.key, required this.receiptId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReceiptBloc>()..add(LoadReceiptById(receiptId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Receipt Details'),
          elevation: 2,
        ),
        body: BlocBuilder<ReceiptBloc, ReceiptState>(
          builder: (context, state) {
            if (state is ReceiptLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReceiptLoaded) {
              return ReceiptDetailWidget(receipt: state.receipt);
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
            return const Center(child: Text('Loading receipt...'));
          },
        ),
      ),
    );
  }
}
