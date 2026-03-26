import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/balance_summary.dart';
import '../widgets/transactions_list.dart';
import '../services/csv_export.dart';
import '../widgets/cyberpunk_text.dart';
import '../widgets/animated_background.dart';
import 'credit_entry_screen.dart';
import 'debit_entry_screen.dart';

class MoneyScreen extends StatelessWidget {
  MoneyScreen({super.key});

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> _showEntryOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.add, color: Colors.white),
                title: const Text('Add Credit',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(sheetContext); // close the bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CreditEntryScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove, color: Colors.white),
                title: const Text('Add Debit',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DebitEntryScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        body: Center(
          child: CyberpunkText(text: 'Error: No User Logged In'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const CyberpunkText(text: 'Money'),
        actions: [
          // CSV Export
          IconButton(
            onPressed: () => ExportService.exportToCSV(userId!),
            icon: const Icon(Icons.table_view, color: Color(0xFF08F7FE)),
          ),
          // PDF Export
          IconButton(
            onPressed: () => ExportService.exportToPDF(userId!),
            icon: const Icon(Icons.picture_as_pdf,
                color: Color(0xFFFF009D)), // Neon Pink
          ),
        ],
      ),
      body: Stack(
        children: [
          const AnimatedBackground(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  BalanceSummary(userId: userId!),
                  const SizedBox(height: 20),
                  TransactionsList(userId: userId!),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEntryOptions(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
