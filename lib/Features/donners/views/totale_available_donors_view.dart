import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:adminbloodv2/Features/donners/widgets/donor_card.dart';
import 'package:adminbloodv2/Features/donners/widgets/donor_dialog.dart';
import 'package:adminbloodv2/Features/donners/widgets/donor_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TotaleAvailableDonorsView extends StatefulWidget {
  const TotaleAvailableDonorsView({super.key});

  @override
  _TotaleAvailableDonorsViewState createState() =>
      _TotaleAvailableDonorsViewState();
}

class _TotaleAvailableDonorsViewState extends State<TotaleAvailableDonorsView> {
  final DonorService _donorService = DonorService();
  String searchQuery = '';

  void editDonor(
      BuildContext context, String docId, Map<String, dynamic> donorData) {
    final nameController =
        TextEditingController(text: donorData[DonorFields.name]);
    final addressController =
        TextEditingController(text: donorData[DonorFields.address]);
    final contactController =
        TextEditingController(text: donorData[DonorFields.contact].toString());
    final bloodTypeController =
        TextEditingController(text: donorData[DonorFields.bloodType]);

    showDialog(
      context: context,
      builder: (context) {
        return DonorDialog(
          nameController: nameController,
          addressController: addressController,
          contactController: contactController,
          bloodTypeController: bloodTypeController,
          onSave: () {
            _donorService.updateDonor(docId, {
              DonorFields.name: nameController.text,
              DonorFields.address: addressController.text,
              DonorFields.contact: int.parse(contactController.text),
              DonorFields.bloodType: bloodTypeController.text,
            }).then((_) {
              Navigator.pop(context);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: ColorsManager.primaryColor,
        title: Text(
          'all_available_donors'.tr(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) =>
                  setState(() => searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                labelText: 'search_by_name_blood_type_or_city'.tr(),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _donorService.fetchDonors(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final donors = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name =
                      (data[DonorFields.name] ?? '').toString().toLowerCase();
                  final bloodType = (data[DonorFields.bloodType] ?? '')
                      .toString()
                      .toLowerCase();
                  return name.contains(searchQuery) ||
                      bloodType.contains(searchQuery);
                }).toList();

                return ListView(
                  children: donors.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return DonorCard(
                      donorData: data,
                      onEdit: () => editDonor(context, doc.id, data),
                      onDelete: () => _donorService.deleteDonor(doc.id),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
