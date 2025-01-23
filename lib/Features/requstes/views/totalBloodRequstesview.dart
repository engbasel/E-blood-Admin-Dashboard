import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

class TotalBloodRequestsView extends StatefulWidget {
  const TotalBloodRequestsView({super.key});

  @override
  _TotalBloodRequestsViewState createState() => _TotalBloodRequestsViewState();
}

class _TotalBloodRequestsViewState extends State<TotalBloodRequestsView> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generatePDF,
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: ColorsManager.backgroundColor,
        title: const Text(
          'Total Blood Requests',
          style: TextStyle(color: ColorsManager.whiteBackgroundColor),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildBloodRequestsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
        decoration: InputDecoration(
          labelText: 'Search by name, blood type, or city',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }

  Widget _buildBloodRequestsList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('neederRequest').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No blood requests available"));
        }

        final filteredDocs = _filterRequests(snapshot.data!.docs);

        return Column(
          children: [
            _buildTotalRequestsCard(filteredDocs.length),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  var request = filteredDocs[index];
                  var requestData = request.data() as Map<String, dynamic>;
                  return _buildRequestCard(request, requestData);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<QueryDocumentSnapshot> _filterRequests(
      List<QueryDocumentSnapshot> docs) {
    return docs.where((doc) {
      final requestData = doc.data() as Map<String, dynamic>;
      final patientName = requestData['patientName']?.toLowerCase() ?? '';
      final bloodType = requestData['bloodType']?.toLowerCase() ?? '';
      final city = requestData['city']?.toLowerCase() ?? '';
      return patientName.contains(searchQuery) ||
          bloodType.contains(searchQuery) ||
          city.contains(searchQuery);
    }).toList();
  }

  Widget _buildTotalRequestsCard(int totalRequests) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: ColorsManager.buttonColor,
        child: ListTile(
          title: const Text(
            'Total Donor Requests',
            style: TextStyle(color: Colors.white),
          ),
          trailing: Text(
            '$totalRequests',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(
      QueryDocumentSnapshot request, Map<String, dynamic> requestData) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      child: ListTile(
        title: Text(
          requestData['patientName'] ?? 'Unknown Name',
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Blood Type: ${requestData['bloodType'] ?? 'Unknown'}\n'
          'City: ${requestData['city'] ?? 'Unknown'}',
          style: const TextStyle(color: Colors.black54),
        ),
        onTap: () => _showRequestDetailsDialog(context, request, requestData),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () {
                // Accept request functionality here
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteRequest(request.id),
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestDetailsDialog(BuildContext context,
      QueryDocumentSnapshot request, Map<String, dynamic> requestData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(requestData['patientName'] ?? 'Request Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Address: ${requestData['address'] ?? 'N/A'}'),
                Text('Blood Type: ${requestData['bloodType'] ?? 'Unknown'}'),
                Text('City: ${requestData['city'] ?? 'Unknown'}'),
                Text('Contact Number: ${requestData['phoneNumber'] ?? 'N/A'}'),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.pop(context);
                _editRequest(context, request.id, requestData);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection('blood_requstes_users')
        .doc(requestId)
        .delete();
  }

  void _editRequest(BuildContext context, String requestId,
      Map<String, dynamic> requestData) {
    // Implement the logic for editing the request here
  }

  Future<void> _generatePDF() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('neederRequest').get();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(level: 0, child: pw.Text('Blood Requests Report')),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>[
                    'Patient Name',
                    'Blood Type',
                    'City',
                    'Contact Number',
                    'Age' // Add this if you want to include age in the report
                  ],
                  ...querySnapshot.docs.map((doc) {
                    final data = doc.data();
                    return [
                      data['patientName']?.toString() ?? 'Unknown',
                      data['bloodType']?.toString() ?? 'Unknown',
                      data['city']?.toString() ?? 'Unknown',
                      data['phoneNumber']?.toString() ?? 'N/A',
                      data['address']?.toString() ??
                          'N/A', // Convert age to String
                    ];
                  }),
                ],
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    await FileSaver.instance.saveFile(
      name: 'blood_requests_report.pdf',
      bytes: bytes,
      ext: 'pdf',
      mimeType: MimeType.pdf,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF saved successfully'),
      ),
    );
  }
}
