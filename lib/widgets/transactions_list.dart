import 'package:bookt/screens/edit_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// If you have an edit transaction screen, keep this import. Otherwise remove it.
// import 'package:bookt/screens/edit_transaction_screen.dart';

class TransactionsList extends StatelessWidget {
  final String userId;
  const TransactionsList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Use the "money" collection for reading
      stream: FirebaseFirestore.instance
          .collection('money')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Color(0xFF08F7FE));
        }
        if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
            'No transactions yet',
            style: TextStyle(color: Colors.white),
          );
        }

        final transactions = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final data = transaction.data() as Map<String, dynamic>;

            final amount = (data['amount'] is num)
                ? (data['amount'] as num).toDouble()
                : 0.0;
            final reason = data['reason'] as String? ?? '';
            final details = data['details'] as String? ?? '';
            final timestamp = (data['timestamp'] as Timestamp).toDate();
            final isCredit = amount > 0;
            final amountColor = isCredit ? Colors.green : Colors.red;

            return Dismissible(
              key: Key(transaction.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) async {
                final messenger = ScaffoldMessenger.of(context);
                await FirebaseFirestore.instance
                    .collection('money')
                    .doc(transaction.id)
                    .delete();
                if (!context.mounted) return;
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Deleted: $reason'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF08F7FE).withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Icon(
                    isCredit ? Icons.arrow_upward : Icons.arrow_downward,
                    color: amountColor,
                  ),
                  title: Text(
                    '${isCredit ? '+' : ''}${NumberFormat.currency(symbol: '₦').format(amount)}',
                    style: TextStyle(
                      color: amountColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reason,
                          style: const TextStyle(color: Colors.white70)),
                      if (details.isNotEmpty)
                        Text(
                          'For: $details',
                          style: const TextStyle(color: Colors.white54),
                        ),
                      Text(
                        DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  // If you don't have an edit screen, remove this trailing icon
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF08F7FE)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTransactionScreen(
                            transactionId: transaction.id,
                            initialAmount: amount,
                            initialReason: reason,
                            initialDetails: details,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
