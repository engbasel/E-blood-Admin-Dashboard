import 'package:adminbloodv2/Features/Home/views/HomeDashboardview.dart';
// import 'package:adminbloodv2/Features/auth/views/Loginview.dart';
// import 'package:adminbloodv2/Features/auth/views/Loginview.dart';
import 'package:adminbloodv2/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BloodAdminApp());
}

class BloodAdminApp extends StatelessWidget {
  const BloodAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // body: AdminLoginView(),
        body: HomeDashboardView(),
      ),
    );
  }
}
