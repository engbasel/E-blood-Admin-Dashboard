import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:adminbloodv2/Core/widgets/buildSummarySection.dart';
import 'package:adminbloodv2/Features/admin/views/AdminView.dart';
import 'package:adminbloodv2/Features/admin/views/RejectedDonorsView.dart';
import 'package:adminbloodv2/Features/admin/views/allowedUsersview.dart';
import 'package:adminbloodv2/Features/users/views/CurrerntUsersAccount.dart';
import 'package:adminbloodv2/FirestoreConstants.dart';

class CoustomrUserssDetailsSection extends StatelessWidget {
  const CoustomrUserssDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Fixed height for the horizontal list
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildSummarySection(
            context,
            'user_accounts'.tr(), // Localized key
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
            'change_user_status'.tr(), // Localized key
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
            'blocked_users'.tr(), // Localized key
            FirestoreConstants.rejectedDonorsCollection,
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const BlockeUSersView();
                },
              ));
            },
          ),
          buildSummarySection(
            context,
            'allowed_users'.tr(), // Localized key
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
