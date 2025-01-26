import 'package:adminbloodv2/Core/widgets/buildSummarySection.dart';
import 'package:adminbloodv2/Features/donners/views/totale_available_donors_view.dart';
import 'package:adminbloodv2/FirestoreConstants.dart';
import 'package:easy_localization/easy_localization.dart';
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
            'all_donors'.tr(), // Localized key
            FirestoreConstants.donorRequestsCollection,
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const TotaleAvailableDonorsView();
                },
              ));
            },
          ),

// BlockedDonorsView
// TotaleAvailableDonorsView
        ],
      ),
    );
  }
}
