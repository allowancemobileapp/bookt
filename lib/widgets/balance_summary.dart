import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BalanceSummary extends StatelessWidget {
  final String userId;

  const BalanceSummary({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Use the "money" collection for reading
      stream: FirebaseFirestore.instance
          .collection('money')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Color(0xFF08F7FE));
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Text(
            'Error loading balance',
            style: TextStyle(color: Colors.red),
          );
        }

        double income = 0;
        double expense = 0;

        for (final doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          // Safely parse the "amount"
          final amount = (data['amount'] is num)
              ? (data['amount'] as num).toDouble()
              : 0.0;

          if (amount > 0) {
            income += amount;
          } else {
            expense += amount.abs();
          }
        }

        final netBalance = income - expense;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF08F7FE).withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBalanceItem('Income', income, Colors.green),
              _buildBalanceItem('Expense', expense, Colors.red),
              _buildBalanceItem(
                'Balance',
                netBalance,
                netBalance >= 0 ? Colors.green : Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          '₦${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
