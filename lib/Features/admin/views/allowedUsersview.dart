import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:adminbloodv2/Features/admin/widgets/UserDetailsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllowedUsersView extends StatelessWidget {
  const AllowedUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Allowed Users',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorsManager.buttonColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('userStat', isEqualTo: 'allowed') // Filter by "allowed" status
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }

        final allowedUsers = snapshot.data!.docs;

        if (allowedUsers.isEmpty) {
          return const Center(
            child: Text(
              'No allowed users found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: allowedUsers.length,
          itemBuilder: (context, index) {
            final user = allowedUsers[index].data() as Map<String, dynamic>;
            final deviceId = allowedUsers[index].id;

            return _buildUserCard(user, deviceId, context);
          },
        );
      },
    );
  }

  Widget _buildUserCard(
      Map<String, dynamic> user, String deviceId, BuildContext context) {
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
          "Status: Allowed",
          style: TextStyle(
            fontSize: 14,
            color: Colors.green.shade700,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 20),
          onPressed: () {
            _navigateToUserDetails(context, user, deviceId);
          },
        ),
      ),
    );
  }

  void _navigateToUserDetails(
      BuildContext context, Map<String, dynamic> user, String deviceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(
          deviceId: deviceId,
          bloodType: user['bloodType'] ?? 'Unknown',
          userStat: 'Allowed',
          condition: user['condition'] ?? 'Unknown',
          contactNumber: user['contactNumber'] ?? 'Unknown',
          email: user['email'] ?? 'Unknown',
          emergencyContact: user['emergencyContact'] ?? 'Unknown',
          name: user['name'] ?? 'Unknown',
          profilePicture: user['profilePicture'] ?? 'Unknown',
          uid: user['uid'] ?? 'Unknown',
        ),
      ),
    );
  }
}
