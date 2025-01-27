import 'package:adminbloodv2/Features/donners/widgets/donor_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
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
    if (timestamp == null) return 'unknown'.tr();
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
            Text(
                '${'address'.tr()}: ${donorData[DonorFields.address] ?? 'nA'.tr()}',
                style: const TextStyle(color: Colors.grey)),
            Text(
                '${'contact'.tr()}: ${donorData[DonorFields.contact] ?? 'nA'.tr()}',
                style: const TextStyle(color: Colors.grey)),
            Text('${'lastDonation'.tr()}: $lastDonationDate',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(donorData[DonorFields.name] ?? 'donorDetails'.tr(),
                    style: const TextStyle(color: Colors.blue)),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                          '${'bloodType'.tr()}: ${donorData[DonorFields.bloodType] ?? 'unknown'.tr()}'),
                      Text(
                          '${'hospitalName'.tr()}: ${donorData[DonorFields.hospitalName] ?? 'unknown'.tr()}'),
                      Text(
                          '${'contact_number'.tr()}: ${donorData[DonorFields.contact] ?? 'nA'.tr()}'),
                      Text('${'lastDonationDate'.tr()}: $lastDonationDate'),
                      Text(
                          '${'age'.tr()}: ${donorData[DonorFields.age] ?? 'unknown'.tr()}'),
                      Text(
                          '${'gender'.tr()}: ${donorData[DonorFields.gender] ?? 'unknown'.tr()}'),
                      Text(
                          '${'medicalConditions'.tr()}: ${donorData[DonorFields.medicalConditions] ?? 'none'.tr()}'),
                      Text(
                          '${'notes'.tr()}: ${donorData[DonorFields.notes] ?? 'none'.tr()}'),
                      Text(
                          '${'units'.tr()}: ${donorData[DonorFields.units] ?? 'unknown'.tr()}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
