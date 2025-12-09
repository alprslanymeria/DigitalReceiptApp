import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digital_receipt_app/features/receipt/presentation/bloc/receipt_bloc.dart';
import 'package:digital_receipt_app/features/receipt/presentation/pages/receipts_page.dart';
import 'package:digital_receipt_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Receipt App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => di.sl<ReceiptBloc>(),
        child: const ReceiptsPage(),
      ),
    );
  }
}
