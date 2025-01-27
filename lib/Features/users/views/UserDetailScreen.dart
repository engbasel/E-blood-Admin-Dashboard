import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:adminbloodv2/Core/widgets/CoustomCircularProgressIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final String userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.whiteBackgroundColor,
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
          'User_Details'.tr(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorsManager.primaryColor,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CoustomCircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading user details.'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Section
                _buildInfoCard(
                  title: 'Name',
                  value: userData['name'] ?? 'N/A',
                  icon: Icons.person,
                ),
                // Email Section
                _buildInfoCard(
                  title: 'Email',
                  value: userData['email'] ?? 'N/A',
                  icon: Icons.email,
                ),
                // Contact Number Section
                _buildInfoCard(
                  title: 'Contact Number',
                  value: userData['contactNumber'] ?? 'N/A',
                  icon: Icons.phone,
                ),
                // Emergency Contact Section
                _buildInfoCard(
                  title: 'Emergency Contact',
                  value: userData['emergencyContact'] ?? 'N/A',
                  icon: Icons.contact_phone,
                ),
                // Blood Type Section
                _buildInfoCard(
                  title: 'Blood Type',
                  value: userData['bloodType'] ?? 'N/A',
                  icon: Icons.bloodtype,
                ),
                // Age Section
                _buildInfoCard(
                  title: 'Age',
                  value: userData['age'] ?? 'N/A',
                  icon: Icons.cake,
                ),
                // Disease Name Section
                _buildInfoCard(
                  title: 'Disease Name',
                  value: userData['diseaseName'] ?? 'N/A',
                  icon: Icons.medical_services,
                ),
                // Location Section
                _buildInfoCard(
                  title: 'Location',
                  value: userData['location'] ?? 'N/A',
                  icon: Icons.location_on,
                ),

                _buildInfoCard(
                  title: 'User ID',
                  value: userData['uId'] ?? 'N/A',
                  icon: Icons.perm_identity,
                ),
                // User Stat Section
                _buildInfoCard(
                  title: 'User Stat',
                  value: userData['userStat'] ?? 'N/A',
                  icon: Icons.star,
                ),
                // User State Section
                _buildInfoCard(
                  title: 'User State',
                  value: userData['userState'] ?? 'N/A',
                  icon: Icons.star_rate_rounded,
                ),
                // Created At Section
                _buildInfoCard(
                  title: 'Account Created At',
                  value: userData['createdAt']?.toDate().toString() ?? 'N/A',
                  icon: Icons.date_range,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required String value, required IconData icon}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: ColorsManager.primaryColor),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryTextColor,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: ColorsManager.secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
