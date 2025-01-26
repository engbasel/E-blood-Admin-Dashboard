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

  // Ensure EasyLocalization is initialized
  await EasyLocalization.ensureInitialized();

  runApp(const BloodAdminApp());
}

class BloodAdminApp extends StatelessWidget {
  const BloodAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/langs', // Path to your translation files
      fallbackLocale: const Locale('en'), // Fallback locale
      startLocale: const Locale('ar'), // Set the initial locale to Arabic
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale, // Use the locale from EasyLocalization
            localizationsDelegates:
                context.localizationDelegates, // Pass localizationDelegates
            supportedLocales: context.supportedLocales, // Pass supportedLocales
            home: const BloodAdminHome(),
          );
        },
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
