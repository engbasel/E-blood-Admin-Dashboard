import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:flutter/material.dart';
import 'package:adminbloodv2/Core/widgets/CoustomCircularProgressIndicator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart'; // Import EasyLocalization

class TotalRejectedRequests extends StatefulWidget {
  const TotalRejectedRequests({super.key});

  @override
  _TotalRejectedRequestsState createState() => _TotalRejectedRequestsState();
}

class _TotalRejectedRequestsState extends State<TotalRejectedRequests> {
  String searchQuery = ''; // Holds the search query

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
          'Rejected Donor Requests',
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
                      isEqualTo: 'rejected') // Filter by rejected status
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CoustomCircularProgressIndicator());
                }

                // Total rejected donor requests count
                final totalRejectedDonorRequests = snapshot.data!.size;

                // Filter rejected donor requests based on the search query
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
                    // Summary card showing total rejected donor requests
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: ColorsManager.buttonColor, // Maroon
                        child: ListTile(
                          title: const Text(
                            'Total Rejected Donor Requests',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                            '$totalRejectedDonorRequests',
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
                                      );
                                    },
                                  );
                                },
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
