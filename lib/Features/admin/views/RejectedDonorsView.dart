import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:adminbloodv2/Features/admin/widgets/UserDetailsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedDonorsView extends StatelessWidget {
  const BlockedDonorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blocked Donors',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorsManager.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('userStat', isEqualTo: 'blocked')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final blockedUsers = snapshot.data!.docs;

          if (blockedUsers.isEmpty) {
            return const Center(
              child: Text(
                'No blocked users found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index].data() as Map<String, dynamic>;
              final deviceId = blockedUsers[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    backgroundImage: user['profilePicture'] != null &&
                            user['profilePicture'].toString().isNotEmpty
                        ? NetworkImage(user['profilePicture'])
                        : null,
                    backgroundColor: ColorsManager.primaryColor,
                    child: user['profilePicture'] == null ||
                            user['profilePicture'].toString().isEmpty
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  title: Text(
                    user['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                  subtitle: Text(
                    "Status: Blocked",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade700,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 20),
                    onPressed: () {
                      // Navigate to user details screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsScreen(
                            deviceId: deviceId,
                            bloodType: user['bloodType'] ?? 'Unknown',
                            userStat: 'Blocked',
                            condition: user['condition'] ?? 'Unknown',
                            contactNumber: user['contactNumber'] ?? 'Unknown',
                            email: user['email'] ?? 'Unknown',
                            emergencyContact:
                                user['emergencyContact'] ?? 'Unknown',
                            name: user['name'] ?? 'Unknown',
                            profilePicture: user['profilePicture'] ?? 'Unknown',
                            uid: user['uid'] ?? 'Unknown',
                          ),
                        ),
                      );
                    },
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
