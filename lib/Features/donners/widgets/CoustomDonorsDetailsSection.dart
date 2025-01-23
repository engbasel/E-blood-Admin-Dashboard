import 'package:adminbloodv2/Core/widgets/buildSummarySection.dart';
import 'package:adminbloodv2/Features/admin/views/AdminView.dart';
import 'package:adminbloodv2/Features/admin/views/RejectedDonorsView.dart';
import 'package:adminbloodv2/Features/admin/views/allowedUsersview.dart';
import 'package:adminbloodv2/Features/users/views/CurrerntUsersAccount.dart';
import 'package:adminbloodv2/FirestoreConstants.dart';
import 'package:flutter/material.dart';

class CoustomDonorsDetailsSection extends StatelessWidget {
  const CoustomDonorsDetailsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Fixed height for the horizontal list
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildSummarySection(
            context,
            'User Accounts',
            FirestoreConstants.userAccountsCollection,
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const CurrentUsersAccount();
                },
              ));
            },
          ),
          buildSummarySection(
            context,
            'Change User Status',
            FirestoreConstants.adminControlCollection,
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const AdminView();
                },
              ));
            },
          ),
          buildSummarySection(
            context,
            'Blocked Users',
            FirestoreConstants.rejectedDonorsCollection,
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const BlockedDonorsView();
                },
              ));
            },
          ),
          buildSummarySection(
            context,
            'Allowed Users',
            FirestoreConstants.rejectedDonorsCollection,
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const AllowedUsersView();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
