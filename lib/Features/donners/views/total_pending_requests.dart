import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:adminbloodv2/Core/widgets/CoustomCircularProgressIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
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
          title: Text('Edit Donor_Details'.tr()),
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
        title: Text(
          'Total_Pending_Donor_Requests'.tr(),
          style: const TextStyle(
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
                labelText:
                    'search_by_name_blood_type_or_city'.tr(), // Localized key

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
                          title: Text(
                            'Total_Pending_Donor_Requests'.tr(),
                            style: const TextStyle(color: Colors.white),
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
                                title: Text(
                                  donorData['fullName'] ?? 'noName'.tr(),
                                  style: const TextStyle(
                                    color: ColorsManager.primaryTextColor,
                                  ),
                                ),
                                subtitle: Text(
                                  '${'bloodType'.tr()}: ${donorData['bloodType'] ?? 'Unknown'}\n${'city'.tr()}: ${donorData['city'] ?? 'Unknown'}',
                                  style: const TextStyle(
                                    color: ColorsManager.secondaryTextColor,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(donorData['fullName'] ??
                                            'donorDetails'.tr()),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              // Address
                                              Text(
                                                  '${'address'.tr()}: ${donorData['address'] ?? 'N/A'}'),

                                              // Blood Type
                                              Text(
                                                  '${'bloodType'.tr()}: ${donorData['bloodType'] ?? 'Unknown'}'),

                                              // City
                                              Text(
                                                  '${'city'.tr()}: ${donorData['city'] ?? 'Unknown'}'),

                                              // Date of Birth
                                              Text(
                                                  '${'dob'.tr()}: ${formattedDateOfBirth ?? 'Unknown'}'),

                                              // Allergies
                                              Text(
                                                  '${'allergies'.tr()}: ${donorData['allergyDetails'] ?? 'None'}'),

                                              // Diagnosed Conditions
                                              Text(
                                                  '${'diagnosedConditions'.tr()}: ${donorData['diagnosedConditions']?.join(', ') ?? 'None'}'),

                                              // Height
                                              Text(
                                                  '${'height'.tr()}: ${donorData['height'] ?? 'Unknown'} cm'),

                                              // Weight
                                              Text(
                                                  '${'weight'.tr()}: ${donorData['weight'] ?? 'Unknown'} kg'),

                                              // Last Donation Date
                                              Text(
                                                  '${'lastDonationDate'.tr()}: ${formattedLastDonationDate ?? 'Unknown'}'),

                                              // Contact Number
                                              Text(
                                                  '${'contactNumber'.tr()}: ${donorData['contact'] ?? 'N/A'}'),

                                              // Age
                                              Text(
                                                  '${'age'.tr()}: ${donorData['age'] ?? 'Unknown'}'),

                                              // Gender
                                              Text(
                                                  '${'gender'.tr()}: ${donorData['gender'] ?? 'Unknown'}'),

                                              // Hospital Name
                                              Text(
                                                  '${'hospitalName'.tr()}: ${donorData['hospitalName'] ?? 'Unknown'}'),

                                              // Medical Conditions
                                              Text(
                                                  '${'medicalConditions'.tr()}: ${donorData['medicalConditions'] ?? 'None'}'),

                                              // Name
                                              Text(
                                                  '${'name'.tr()}: ${donorData['name'] ?? 'Unknown'}'),

                                              // Notes
                                              Text(
                                                  '${'notes'.tr()}: ${donorData['notes'] ?? 'None'}'),

                                              // Units
                                              Text(
                                                  '${'units'.tr()}: ${donorData['units'] ?? 'Unknown'}'),
                                            ],
                                          ),
                                        ),
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
