import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:adminbloodv2/Core/widgets/CoustomCircularProgressIndicator.dart';
import 'package:adminbloodv2/Features/users/views/UserDetailScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentUsersAccount extends StatelessWidget {
  const CurrentUsersAccount({super.key});

  Future<void> _deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

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
        title: const Text(
          'Current Users Account',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor:
            ColorsManager.primaryColor, // Use primary color for app bar
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CoustomCircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userData = user.data();

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: ColorsManager
                    .whiteBackgroundColor, // Set card background color
                elevation: 2, // Add shadow for elevation
                child: ListTile(
                  title: Text(
                    userData['name'] ?? 'No Name',
                    style: const TextStyle(
                        color: ColorsManager
                            .primaryTextColor), // Set title text color
                  ),
                  subtitle: Text(
                    'Email: ${userData['email'] ?? 'N/A'}',
                    style: const TextStyle(
                        color: ColorsManager
                            .secondaryTextColor), // Set subtitle text color
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailScreen(userId: user.id),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete,
                        color: ColorsManager
                            .errorColor), // Use error color for delete icon
                    onPressed: () => _deleteUser(user.id),
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
