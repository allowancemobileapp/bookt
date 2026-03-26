import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_saver/file_saver.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportService {
  // --- CSV EXPORT ---
  static Future<void> exportToCSV(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('money')
          .where('userId', isEqualTo: userId)
          .get();

      final data = snapshot.docs.map((doc) {
        final map = doc.data();
        final amount = (map['amount'] as num? ?? 0).toDouble();
        final timestamp =
            (map['timestamp'] as Timestamp?)?.toDate().toString() ?? 'No Date';

        return [
          timestamp,
          amount > 0 ? 'Credit' : 'Debit',
          map['reason'] ?? 'No Reason',
          map['details'] ?? '',
          'N${amount.abs().toStringAsFixed(2)}',
        ];
      }).toList();

      const header = ['Date', 'Type', 'Reason', 'For', 'Amount'];
      String csvData = const ListToCsvConverter().convert([header, ...data]);

      // Convert String to Uint8List for the saver
      Uint8List bytes = Uint8List.fromList(csvData.codeUnits);

      await FileSaver.instance.saveFile(
        name: 'transactions',
        bytes: bytes,
        ext: 'csv',
        mimeType: MimeType.csv,
      );
    } catch (e) {
      print("CSV Export Error: $e");
    }
  }

  // --- PDF EXPORT ---
  static Future<void> exportToPDF(String userId) async {
    try {
      final pdf = pw.Document();
      final snapshot = await FirebaseFirestore.instance
          .collection('money')
          .where('userId', isEqualTo: userId)
          .get();

      final List<List<String>> tableData = snapshot.docs.map((doc) {
        final map = doc.data();
        final amount = (map['amount'] as num? ?? 0).toDouble();
        final date = (map['timestamp'] as Timestamp?)
                ?.toDate()
                .toString()
                .split(' ')[0] ??
            'N/A';

        return [
          date,
          (map['reason'] ?? 'No Reason').toString(),
          'N${amount.toStringAsFixed(2)}',
        ];
      }).toList();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Text("Book't Transaction Report",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Date', 'Reason', 'Amount'],
                data: tableData,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          ),
        ),
      );

      // Save PDF and trigger download
      Uint8List pdfBytes = await pdf.save();

      await FileSaver.instance.saveFile(
        name: 'transactions_report',
        bytes: pdfBytes,
        ext: 'pdf',
        mimeType: MimeType.pdf,
      );
    } catch (e) {
      print("PDF Export Error: $e");
    }
  }
}
