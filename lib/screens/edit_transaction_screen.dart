import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class EditTransactionScreen extends StatefulWidget {
  final String transactionId;
  final double initialAmount;
  final String initialReason;
  final String initialDetails;

  const EditTransactionScreen({
    super.key,
    required this.transactionId,
    required this.initialAmount,
    required this.initialReason,
    required this.initialDetails,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late TextEditingController _amountController;
  late TextEditingController _reasonController;
  late TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();

    // Check if user is logged in
    if (FirebaseAuth.instance.currentUser == null) {
      Future.microtask(() {
        if (mounted) {
          // ✅ --- THIS IS THE KEY FIX: `mounted` check
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    }

    _amountController =
        TextEditingController(text: widget.initialAmount.toString());
    _reasonController = TextEditingController(text: widget.initialReason);
    _detailsController = TextEditingController(text: widget.initialDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Edit Transaction',
            style: TextStyle(color: Color(0xFF00FF9D))),
        backgroundColor: Colors.black,
        actions: [
          Shimmer.fromColors(
            baseColor: const Color(0xFF00FF9D),
            highlightColor: const Color(0xFFFF009D),
            child: IconButton(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _amountController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Color(0xFF00FF9D))),
                keyboardType: TextInputType.number),
            TextField(
                controller: _reasonController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: 'Reason',
                    labelStyle: TextStyle(color: Color(0xFF00FF9D)))),
            TextField(
                controller: _detailsController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: 'For?',
                    labelStyle: TextStyle(color: Color(0xFF00FF9D)))),
          ],
        ),
      ),
    );
  }

  void _saveChanges() async {
    final newAmount = double.tryParse(_amountController.text);
    if (newAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('money')
        .doc(widget.transactionId)
        .update({
      'amount': newAmount,
      'reason': _reasonController.text,
      'details': _detailsController.text,
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction updated!'),
          backgroundColor: Color(0xFF08F7FE),
        ),
      );
    }
  }
}
