// import 'package:adminbloodv2/Core/widgets/buildSummarySection.dart';
// import 'package:adminbloodv2/Features/donners/views/totale_available_donors_view.dart';
// import 'package:adminbloodv2/FirestoreConstants.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// class CoustomDonorsDetailsSection extends StatelessWidget {
//   const CoustomDonorsDetailsSection({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 150, // Fixed height for the horizontal list
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: [
//           buildSummarySection(
//             context,
//             'all_donors'.tr(), // Localized key
//             FirestoreConstants.donorRequestsCollection,
//             () {
//               Navigator.push(context, MaterialPageRoute(
//                 builder: (context) {
//                   return const TotaleAvailableDonorsView();
//                 },
//               ));
//             },
//           ),

//           Container(
//             child: const Text(
//                 'سوف يتم العمل علي هذة الخاصية في الترم المقبل و استكمال باقي وسائل التحكم '),
//           ),

// // BlockedDonorsView
// // TotaleAvailableDonorsView
//         ],
//       ),
//     );
//   }
// }

import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
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
          buildSummarySection(
            context,
            'verified_donors_list'.tr(), // Localized key
            FirestoreConstants.donorRequestsCollection,
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const TotaleAvailableDonorsView();
                },
              ));
            },
          ),
          GestureDetector(
            onTap: () {
              _showFeatureComingSoon(context);
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: ColorsManager.backgroundColor, // Use from ColorsManager
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                textAlign: TextAlign.center,
                'سوف يتم العمل علي هذة الخاصية في الترم المقبل و استكمال باقي وسائل التحكم',
                style: TextStyle(
                  color: ColorsManager
                      .whiteBackgroundColor, // Use from ColorsManager
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showFeatureComingSoon(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text(
        'هذه الخاصية غير متوفرة حالياً، سوف يتم العمل على هذه الخاصية في المرحلة القادمة (الترم الثاني)',
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      backgroundColor: ColorsManager.primaryColor, // Use primary color
      duration: const Duration(seconds: 3), // Display for 3 seconds
      behavior: SnackBarBehavior.floating, // Make it floating
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
    ),
  );
}
