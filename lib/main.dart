import 'package:adminbloodv2/Features/Home/views/HomeDashboardview.dart';
import 'package:adminbloodv2/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';

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
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        home: const BloodAdminHome(),
      ),
    );
  }
}

class BloodAdminHome extends StatelessWidget {
  const BloodAdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeDashboardView(),
    );
  }
}
