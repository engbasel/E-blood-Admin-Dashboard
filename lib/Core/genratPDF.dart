import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> generateBloodRequestsPDF(
  List<QueryDocumentSnapshot> requests,
) async {
  final pdf = pw.Document();

  // Calculate the total count of requests
  final totalRequests = requests.length;

  // Add content to the PDF
  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.all(20),
      build: (pw.Context context) {
        return pw.Directionality(
          textDirection: pw.TextDirection.rtl, // Set the entire page to RTL
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title
              pw.Center(
                child: pw.Text(
                  'تقرير طلبات الدم',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.red800,
                  ),
                ),
              ),
              pw.Divider(thickness: 2, color: PdfColors.red800),
              pw.SizedBox(height: 20),

              // Table for requests
              pw.Text(
                'تفاصيل الطلبات',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Table.fromTextArray(
                headers: [
                  'اسم المريض',
                  'فصيلة الدم',
                  'المدينة',
                  'رقم الاتصال',
                  'اسم المرافق',
                  'ملاحظات إضافية',
                  'المرض',
                  'الحالة',
                  'السبب',
                  'التاريخ',
                ],
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.red800,
                ),
                cellStyle: const pw.TextStyle(fontSize: 9),
                cellHeight: 25,
                cellAlignment:
                    pw.Alignment.centerRight, // Align text to the right
                data: requests.map((request) {
                  final data = request.data() as Map<String, dynamic>;
                  return [
                    data['patientName'] ?? 'N/A',
                    data['bloodType'] ?? 'N/A',
                    data['location'] ?? 'N/A',
                    data['contactNumber'] ?? 'N/A',
                    data['accompanyName'] ?? 'N/A',
                    data['additionalNotes'] ?? 'N/A',
                    data['diseaseName'] ?? 'N/A',
                    data['urgent'] ?? 'N/A',
                    data['reason'] ?? 'N/A',
                    data['timestamp'] != null
                        ? (data['timestamp'] as Timestamp?)
                                ?.toDate()
                                .toString() ??
                            'N/A'
                        : 'N/A',
                  ];
                }).toList(),
              ),

              pw.SizedBox(height: 30),

              // Summary Section
              pw.Text(
                'ملخص',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('إجمالي الطلبات: $totalRequests'),
                    pw.Text(
                      'الطلبات العاجلة: ${requests.where((request) => (request.data() as Map<String, dynamic>?)?['urgent'] == 'yes').length}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  // Save or print the PDF
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
