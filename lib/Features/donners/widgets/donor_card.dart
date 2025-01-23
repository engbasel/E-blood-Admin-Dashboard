// donor_card.dart

import 'package:adminbloodv2/Features/donners/widgets/donor_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DonorCard extends StatelessWidget {
  final Map<String, dynamic> donorData;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DonorCard({
    super.key,
    required this.donorData,
    required this.onEdit,
    required this.onDelete,
  });

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final DateTime date = timestamp.toDate();
    return DateFormat('MM/dd/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final String lastDonationDate =
        formatDate(donorData[DonorFields.lastRequestDate]);

    return Card(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: ListTile(
        title: Text(
          '${donorData[DonorFields.name]} (${donorData[DonorFields.bloodType]})',
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: ${donorData[DonorFields.address]}',
                style: const TextStyle(color: Colors.grey)),
            Text('Contact: ${donorData[DonorFields.contact]}',
                style: const TextStyle(color: Colors.grey)),
            Text('Last Donation: $lastDonationDate',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(donorData[DonorFields.name] ?? 'Donor Details',
                    style: const TextStyle(color: Colors.blue)),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                          'Blood Type: ${donorData[DonorFields.bloodType] ?? 'Unknown'}'),
                      Text(
                          'Hospital Name: ${donorData[DonorFields.hospitalName] ?? 'Unknown'}'),
                      Text(
                          'Contact: ${donorData[DonorFields.contact] ?? 'N/A'}'),
                      Text('Last Donation Date: $lastDonationDate'),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
