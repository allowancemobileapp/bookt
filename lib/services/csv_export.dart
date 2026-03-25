// Update lib/services/csv_export.dart
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CSVExport {
  static Future<void> exportToCSV(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('money')
        .where('userId', isEqualTo: userId)
        .get();

    final data = snapshot.docs.map((doc) {
      final amount = doc['amount'] as double;
      return [
        doc['timestamp'].toDate().toString(),
        amount > 0 ? 'Credit' : 'Debit',
        doc['reason'],
        doc['details'] ?? '',
        '₦${amount.abs().toStringAsFixed(2)}',
      ];
    }).toList();

    const header = ['Date', 'Type', 'Reason', 'For', 'Amount'];
    final csvData = const ListToCsvConverter().convert([header, ...data]);

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/transactions.csv');
    await file.writeAsString(csvData);

    await Share.shareXFiles([XFile(file.path)]);
  }
}
