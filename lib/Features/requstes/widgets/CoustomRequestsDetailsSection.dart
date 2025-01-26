import 'package:adminbloodv2/Core/widgets/buildSummarySection.dart';
import 'package:adminbloodv2/Features/donners/views/total_pending_requests.dart';
import 'package:adminbloodv2/Features/donners/views/totale_available_donors_view.dart';
import 'package:adminbloodv2/FirestoreConstants.dart';
import 'package:easy_localization/easy_localization.dart'; // Import EasyLocalization
import 'package:flutter/material.dart';

import '../views/total_blood_requstes_view.dart';

class CoustomRequestsDetailsSection extends StatelessWidget {
  const CoustomRequestsDetailsSection({
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
            'total_blood_requests'.tr(), // Localized key
            FirestoreConstants.bloodRequestsCollection,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const TotalBloodRequestsView();
                  },
                ),
              );
            },
          ),
          buildSummarySection(
            context,
            'pending_donation_requests'.tr(), // Localized key
            FirestoreConstants.donorRequestsCollection,
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const TotalPendingRequests();
                },
              ));
            },
          ),
          buildSummarySection(
            context,
            'verified_donors_list'.tr(), // Localized key
            FirestoreConstants.verifiedDonorsCollection,
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const TotaleAvailableDonorsView();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
