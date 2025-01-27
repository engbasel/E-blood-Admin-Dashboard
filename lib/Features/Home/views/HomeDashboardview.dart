import 'package:adminbloodv2/Features/donners/widgets/CoustomDonorsDetailsSection.dart';
import 'package:adminbloodv2/Features/requstes/widgets/CoustomRequestsDetailsSection.dart';
import 'package:adminbloodv2/Features/users/views/CoustomrUserssDetailsSection.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:adminbloodv2/Features/Home/widgets/buildDrawerItem.dart';

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: ColorsManager.backgroundColor,
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          'dashboard_title'.tr(),
          style: const TextStyle(
            color: ColorsManager.buttonColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      // drawer: Drawer(
      //   backgroundColor: Colors.white,
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       const DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: ColorsManager.primaryColor,
      //         ),
      //         child: Text(
      //           'Blood Charity Admin',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //       buildDrawerItem(Icons.person, 'user_requests'.tr(), () {
      //         // Add navigation logic if needed
      //       }),
      //       buildDrawerItem(Icons.favorite, 'pending_donor_requests'.tr(), () {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => const TotalPendingRequests()));
      //       }),
      //       buildDrawerItem(Icons.report, 'view_reports'.tr(), () {
      //         // Add navigation logic for reports
      //       }),
      //       buildDrawerItem(Icons.settings, 'settings'.tr(), () {
      //         // Add navigation logic for settings
      //       }),
      //       const Text(
      //           'مرحبا بكم جميعا في بيتكم الثاني كلية الهندسة جامعة المنصورة لمناقشة زملاء الغد في مشروعهم'),
      //       const Text(
      //           'كل الشكر لجميع الاشخاص الذين شاركوا في انتاج هذا المشروع ونطمح ان يكون نال اعجابكم جميعا و ممتنين لمجهود و ثقة اساتذتنا الاعزاء '),
      //     ],
      //   ),
      // ),
      // drawer: Drawer(
      //   backgroundColor: Colors.white,
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       // Drawer Header
      //       const DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: ColorsManager.primaryColor, // Use primary color
      //         ),
      //         child: Text(
      //           'Blood Charity Admin',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            const DrawerHeader(
              decoration: BoxDecoration(
                color: ColorsManager.primaryColor, // Use primary color
              ),
              child: Text(
                'Blood Charity Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Drawer Items
            buildDrawerItem(Icons.person, 'user_requests'.tr(), () {
              _showFeatureComingSoon(context); // Show message
            }),
            buildDrawerItem(Icons.favorite, 'pending_donor_requests'.tr(), () {
              _showFeatureComingSoon(context); // Show message
            }),
            buildDrawerItem(Icons.report, 'view_reports'.tr(), () {
              _showFeatureComingSoon(context); // Show message
            }),
            buildDrawerItem(Icons.settings, 'settings'.tr(), () {
              _showFeatureComingSoon(context); // Show message
            }),

            // Divider
            const Divider(
              color: Colors.grey, // Use a subtle color for the divider
              thickness: 1,
              height: 20,
            ),

            // Welcome Message Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً بكم جميعاً',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryColor, // Use primary color
                    ),
                  ),
                  SizedBox(height: 8), // Spacing
                  Text(
                    'في بيتكم الثاني كلية الهندسة جامعة المنصورة لمناقشة زملاء الغد في مشروعهم',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey, // Use a secondary color
                    ),
                  ),
                  SizedBox(height: 16), // Spacing
                  Text(
                    'كل الشكر لجميع الأشخاص الذين شاركوا في إنتاج هذا المشروع، ونطمح أن يكون نال إعجابكم جميعاً. ممتنين لمجهود وثقة أساتذتنا الأعزاء.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey, // Use a secondary color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              'requests_details'.tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CoustomRequestsDetailsSection(),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              'donors_details'.tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CoustomDonorsDetailsSection(),
            const SizedBox(height: 20),
            const Divider(), const SizedBox(height: 20),

            Text(
              'users_info'.tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            const CoustomrUserssDetailsSection(),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            // Text(
            //   'reports'.tr(),
            //   style: const TextStyle(
            //     fontSize: 22,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 20),
            // const ReportsChartsSection(),
          ],
        ),
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
