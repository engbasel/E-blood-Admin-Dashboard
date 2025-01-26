import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:adminbloodv2/Core/widgets/CoustomCircularProgressIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalPendingRequests extends StatefulWidget {
  const TotalPendingRequests({super.key});

  @override
  _TotalPendingRequestsState createState() => _TotalPendingRequestsState();
}

class _TotalPendingRequestsState extends State<TotalPendingRequests> {
  String searchQuery = ''; // Holds the search query

  // Function to accept a donor request and add to verified collection
  void acceptRequest(String docId, Map<String, dynamic> donorData) async {
    await FirebaseFirestore.instance
        .collection('neederRequest')
        .add(donorData); // Add the donor data to the verified collection
    await FirebaseFirestore.instance
        .collection('neederRequest')
        .doc(docId)
        .delete(); // Remove from unverified collection
  }

  // Function to delete a donor request
  void deleteRequest(String docId) async {
    await FirebaseFirestore.instance
        .collection('neederRequest')
        .doc(docId)
        .delete();
  }

  // Function to edit a donor request
  void editRequest(
      BuildContext context, String docId, Map<String, dynamic> donorData) {
    TextEditingController fullNameController =
        TextEditingController(text: donorData['fullName']);
    TextEditingController cityController =
        TextEditingController(text: donorData['city']);
    TextEditingController bloodTypeController =
        TextEditingController(text: donorData['bloodType']);
    TextEditingController phoneNumberController =
        TextEditingController(text: donorData['phoneNumber']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Donor Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                TextField(
                  controller: bloodTypeController,
                  decoration: const InputDecoration(labelText: 'Blood Type'),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Contact Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update Firestore document with new data
                await FirebaseFirestore.instance
                    .collection('neederRequest')
                    .doc(docId)
                    .update({
                  'fullName': fullNameController.text,
                  'city': cityController.text,
                  'bloodType': bloodTypeController.text,
                  'phoneNumber': phoneNumberController.text,
                });

                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Pending Donor Requests',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorsManager.primaryColor, // Dark Red
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by name, blood type, or city',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('neederRequest')
                  .where('status',
                      isEqualTo: 'pending') // Filter by pending status
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CoustomCircularProgressIndicator());
                }

                // Total pending donor requests count
                final totalPendingDonorRequests = snapshot.data!.size;

                // Filter pending donor requests based on the search query
                final filteredDocs = snapshot.data!.docs.where((doc) {
                  final donorData = doc.data() as Map<String, dynamic>;
                  final fullName =
                      (donorData['fullName'] ?? '').toString().toLowerCase();
                  final bloodType =
                      (donorData['bloodType'] ?? '').toString().toLowerCase();
                  final city =
                      (donorData['city'] ?? '').toString().toLowerCase();

                  return fullName.contains(searchQuery) ||
                      bloodType.contains(searchQuery) ||
                      city.contains(searchQuery);
                }).toList();

                return Column(
                  children: [
                    // Summary card showing total pending donor requests
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: ColorsManager.buttonColor, // Maroon
                        child: ListTile(
                          title: const Text(
                            'Total Pending Donor Requests',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                            '$totalPendingDonorRequests',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ListView.builder(
                          itemCount: filteredDocs.length,
                          itemBuilder: (context, index) {
                            final doc = filteredDocs[index];
                            final donorData =
                                doc.data() as Map<String, dynamic>;

                            // Formatting date fields
                            final DateFormat dateFormat =
                                DateFormat('MM/dd/yyyy');
                            final String formattedDateOfBirth =
                                donorData['dateOfBirth'] != null
                                    ? dateFormat.format(
                                        (donorData['dateOfBirth'] as Timestamp)
                                            .toDate())
                                    : 'Unknown';
                            final String formattedLastDonationDate =
                                donorData['lastDonationDate'] != null
                                    ? dateFormat.format(
                                        (donorData['lastDonationDate']
                                                as Timestamp)
                                            .toDate())
                                    : 'Unknown';

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                              child: ListTile(
                                title: Text(donorData['fullName'] ?? 'No Name',
                                    style: const TextStyle(
                                      color: ColorsManager.primaryTextColor,
                                    )),
                                subtitle: Text(
                                  'Blood Type: ${donorData['bloodType'] ?? 'Unknown'}\n'
                                  'City: ${donorData['city'] ?? 'Unknown'}',
                                  style: const TextStyle(
                                    color: ColorsManager.secondaryTextColor,
                                  ),
                                ),
                                onTap: () {
                                  // Show detailed information dialog on tap
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(donorData['fullName'] ??
                                            'Donor Details'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Text(
                                                  'Address: ${donorData['address'] ?? 'N/A'}'),
                                              Text(
                                                  'Blood Type: ${donorData['bloodType'] ?? 'Unknown'}'),
                                              Text(
                                                  'City: ${donorData['city'] ?? 'Unknown'}'),
                                              Text(
                                                  'Date of Birth: $formattedDateOfBirth'),
                                              Text(
                                                  'Allergies: ${donorData['allergyDetails'] ?? 'None'}'),
                                              Text(
                                                  'Diagnosed Conditions: ${donorData['diagnosedConditions']?.join(', ') ?? 'None'}'),
                                              Text(
                                                  'Height: ${donorData['height'] ?? 'Unknown'} cm'),
                                              Text(
                                                  'Weight: ${donorData['weight'] ?? 'Unknown'} kg'),
                                              Text(
                                                  'Last Donation Date: $formattedLastDonationDate'),
                                              Text(
                                                  'Contact Number: ${donorData['phoneNumber'] ?? 'N/A'}'),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color:
                                                    ColorsManager.buttonColor),
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close details dialog
                                              editRequest(context, doc.id,
                                                  donorData); // Open edit dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.check,
                                          color: ColorsManager
                                              .successColor), // Green
                                      onPressed: () {
                                        acceptRequest(doc.id, donorData);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color:
                                              ColorsManager.errorColor), // Red
                                      onPressed: () {
                                        deleteRequest(doc.id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
