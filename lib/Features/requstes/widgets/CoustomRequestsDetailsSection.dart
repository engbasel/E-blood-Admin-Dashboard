import 'package:adminbloodv2/Core/widgets/buildSummarySection.dart';
import 'package:adminbloodv2/Features/donners/views/total_pending_requests.dart';
import 'package:adminbloodv2/Features/donners/views/totale_available_donors_view.dart';
import 'package:adminbloodv2/Features/requstes/views/totalBloodRequstesview.dart';
import 'package:adminbloodv2/FirestoreConstants.dart';
import 'package:flutter/material.dart';

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
            'Total Blood Requests',
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
            'Pending Donation Requests',
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
            'Verified Donors List',
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
