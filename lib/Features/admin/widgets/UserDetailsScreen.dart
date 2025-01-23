import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final String deviceId;
  final String userStat;
  final String bloodType;
  final String condition;
  final String? contactNumber;
  final String email;
  final String emergencyContact;
  final String name;
  final String profilePicture;
  final String uid;

  const UserDetailsScreen({
    super.key,
    required this.deviceId,
    required this.bloodType,
    required this.userStat,
    required this.condition,
    this.contactNumber,
    required this.email,
    required this.emergencyContact,
    required this.name,
    required this.profilePicture,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "User Details",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: profilePicture.isNotEmpty
                      ? NetworkImage(profilePicture)
                      : null,
                  child: profilePicture.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildUserInfoTile("Device ID", deviceId),
              _buildUserInfoTile("Name", name),
              _buildUserInfoTile("Blood Type", bloodType),
              _buildUserInfoTile("Condition", condition),
              _buildUserInfoTile(
                  "Contact Number", contactNumber ?? 'Not provided'),
              _buildUserInfoTile("Email", email),
              _buildUserInfoTile("Emergency Contact", emergencyContact),
              _buildUserInfoTile("UID", uid),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Status: $userStat",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: userStat == 'Allowed' ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
