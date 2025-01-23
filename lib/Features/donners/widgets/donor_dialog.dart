// donor_dialog.dart

import 'package:flutter/material.dart';

class DonorDialog extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController contactController;
  final TextEditingController bloodTypeController;
  final VoidCallback onSave;

  const DonorDialog({
    super.key,
    required this.nameController,
    required this.addressController,
    required this.contactController,
    required this.bloodTypeController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Donor'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Contact'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: bloodTypeController,
              decoration: const InputDecoration(labelText: 'Blood Type'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: onSave,
          child: const Text('Save', style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
