import 'package:file_saver/file_saver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  // Generate a PDF from Firestore data with Arabic support
  static Future<void> generatePdf({
    required String collectionName,
    required List<String> headers,
    required List<String> fields,
    required String fileName,
    required BuildContext context,
  }) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();
    final pdf = pw.Document();

    // Load an Arabic font (e.g., Amiri Regular)
    final arabicFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Amiri-Regular.ttf'));

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.end, // Align to the right
                children: [
                  pw.Header(
                    level: 0,
                    child: pw.Text(
                      _fixArabicText('تقرير طلبات الدم'), // Fix Arabic text
                      style: pw.TextStyle(font: arabicFont, fontSize: 24),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Table.fromTextArray(
                    context: context,
                    columnWidths: {
                      for (var i = 0; i < headers.length; i++)
                        i: const pw.FlexColumnWidth(1),
                    },
                    data: <List<String>>[
                      headers.map((header) => _fixArabicText(header)).toList(),
                      ...querySnapshot.docs.map((doc) {
                        final data = doc.data();
                        return fields.map((field) {
                          return _fixArabicText(
                              data[field]?.toString() ?? 'N/A');
                        }).toList();
                      }),
                    ],
                    cellStyle: pw.TextStyle(font: arabicFont, fontSize: 12),
                    headerStyle: pw.TextStyle(
                      font: arabicFont,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    defaultColumnWidth: const pw.FlexColumnWidth(1),
                    tableWidth: pw.TableWidth.max,
                  ),
                ],
              ));
        },
      ),
    );

    final bytes = await pdf.save();
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      ext: 'pdf',
      mimeType: MimeType.pdf,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ ملف PDF بنجاح'),
      ),
    );
  }

  // Helper function to fix Arabic text rendering issues
  static String _fixArabicText(String text) {
    return text.split('').reversed.join();
  }
}
