import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;

class TotalBloodRequestsView extends StatefulWidget {
  const TotalBloodRequestsView({super.key});

  @override
  TotalBloodRequestsViewState createState() => TotalBloodRequestsViewState();
}

class TotalBloodRequestsViewState extends State<TotalBloodRequestsView> {
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
      final city = requestData['address']?.toLowerCase() ?? '';
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
          'City: ${requestData['address'] ?? 'Unknown'}\n'
          'Status: ${requestData['status'] ?? 'Unknown'}',
          style: const TextStyle(color: Colors.black54),
        ),
        onTap: () => _showRequestDetailsDialog(context, request, requestData),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _updateStatus(request.id, 'accepted'),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _updateStatus(request.id, 'rejected'),
            ),
            IconButton(
              icon: const Icon(Icons.pending, color: Colors.red),
              onPressed: () => _updateStatus(request.id, 'pending'),
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
                Text('City: ${requestData['address'] ?? 'Unknown'}'),
                Text('Contact Number: ${requestData['contact'] ?? 'N/A'}'),
                Text('Status: ${requestData['status'] ?? 'Unknown'}'),
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

  Future<void> _updateStatus(String requestId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('neederRequest')
        .doc(requestId)
        .update({'status': newStatus});
  }

  Future<void> _deleteRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection('neederRequest')
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
              pw.TableHelper.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>[
                    'Patient Name',
                    'Blood Type',
                    'City',
                    'Contact Number',
                    'Status'
                  ],
                  ...querySnapshot.docs.map((doc) {
                    final data = doc.data();
                    return [
                      data['patientName'] ?? 'Unknown',
                      data['bloodType'] ?? 'Unknown',
                      data['address'] ?? 'Unknown',
                      data['contact']?.toString() ?? 'N/A',
                      data['status'] ?? 'Unknown',
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
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF saved successfully'),
      ),
    );
  }
}
