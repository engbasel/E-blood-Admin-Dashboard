import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:adminbloodv2/Features/admin/widgets/UserDetailsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserStatesListTile extends StatelessWidget {
  const UserStatesListTile({
    super.key,
    required this.deviceId,
    required this.isAllowed,
    required this.data,
  });

  final String deviceId;
  final bool isAllowed;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          backgroundImage: data['profilePicture'] != null &&
                  data['profilePicture'].toString().isNotEmpty
              ? NetworkImage(data['profilePicture'])
              : null,
          backgroundColor: ColorsManager.primaryColor,
          child: data['profilePicture'] == null ||
                  data['profilePicture'].toString().isEmpty
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
        title: Text(
          data['name'] ?? 'Unknown',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: ColorsManager.primaryColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email: ${data['email'] ?? 'Unknown'}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            Text(
              "Blood Type: ${data['bloodType'] ?? 'Unknown'}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            Text(
              "Status: ${isAllowed ? 'Allowed' : 'Blocked'}",
              style: TextStyle(
                fontSize: 14,
                color: isAllowed ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        trailing: Switch(
          value: isAllowed,
          onChanged: (value) async {
            String newStatus = value ? 'allowed' : 'blocked';
            try {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(deviceId)
                  .update({'userStat': newStatus});
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User access updated to: $newStatus'),
                ),
              );
            } catch (e) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update user access: $e'),
                ),
              );
            }
          },
          activeColor: ColorsManager.primaryColor,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailsScreen(
                deviceId: deviceId,
                bloodType: data['bloodType'] ?? 'Unknown',
                userStat: isAllowed ? 'Allowed' : 'Blocked',
                condition: data['condition'] ?? 'Unknown',
                contactNumber: data['contactNumber'] ?? 'Unknown',
                email: data['email'] ?? 'Unknown',
                emergencyContact: data['emergencyContact'] ?? 'Unknown',
                name: data['name'] ?? 'Unknown',
                profilePicture: data['profilePicture'] ?? 'Unknown',
                uid: data['uid'] ?? 'Unknown',
              ),
            ),
          );
        },
      ),
    );
  }
}
