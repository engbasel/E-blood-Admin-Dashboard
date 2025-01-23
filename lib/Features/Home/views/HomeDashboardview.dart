import 'package:adminbloodv2/Features/donners/widgets/CoustomDonorsDetailsSection.dart';
import 'package:adminbloodv2/Features/reports/widgets/CoustomReportsSection.dart';
import 'package:adminbloodv2/Features/requstes/widgets/CoustomRequestsDetailsSection.dart';
import 'package:flutter/material.dart';

import 'package:adminbloodv2/Features/donners/views/total_pending_requests.dart';

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
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: ColorsManager.buttonColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: ColorsManager.primaryColor,
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
            buildDrawerItem(Icons.person, 'User Requests', () {
              // Add navigation logic if needed
            }),
            buildDrawerItem(Icons.favorite, 'Pending Donor Requests', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TotalPendingRequests()));
            }),
            buildDrawerItem(Icons.report, 'View Reports', () {
              // Add navigation logic for reports
            }),
            buildDrawerItem(Icons.settings, 'Settings', () {
              // Add navigation logic for settings
            }),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Text(
              'Requests Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CoustomRequestsDetailsSection(),
            SizedBox(
              height: 20,
            ),
            Divider(),
            SizedBox(height: 20),
            Text(
              'Donors Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CoustomDonorsDetailsSection(),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Text(
              'Reports',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ReportsChartsSection()
          ],
        ),
      ),
    );
  }
}
