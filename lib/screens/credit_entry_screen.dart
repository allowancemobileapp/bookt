import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/money_bloc.dart';

class CreditEntryScreen extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  CreditEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Theme handles background & AppBar color
      appBar: AppBar(
        title: const Text('New Credit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'How much?',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Why?',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveCredit(context),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCredit(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No user logged in!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount!')),
      );
      return;
    }

    context.read<MoneyBloc>().add(
          AddMoneyEntry(
            amount: amount,
            reason: _reasonController.text,
            userId: user.uid,
            isCredit: true,
          ),
        );
    Navigator.pop(context);
  }
}
