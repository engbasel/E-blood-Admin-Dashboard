import 'package:adminbloodv2/Features/Home/views/HomeDashboardview.dart';
import 'package:flutter/material.dart';
import 'package:adminbloodv2/Core/manger/ColorsManager.dart';

class AdminLoginView extends StatelessWidget {
  const AdminLoginView({super.key});

  // Define username and password constants
  static const String _username = "admin";
  static const String _password = "basel";

  @override
  Widget build(BuildContext context) {
    // Controllers to get input values
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: ColorsManager.whiteBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Admin Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryTextColor,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle:
                      const TextStyle(color: ColorsManager.secondaryTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: ColorsManager.primaryColor),
                  ),
                  prefixIcon: const Icon(Icons.person,
                      color: ColorsManager.primaryColor),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                      const TextStyle(color: ColorsManager.secondaryTextColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: ColorsManager.primaryColor),
                  ),
                  prefixIcon:
                      const Icon(Icons.lock, color: ColorsManager.primaryColor),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Check if entered username and password match the constants
                  if (usernameController.text == _username &&
                      passwordController.text == _password) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeDashboardView(),
                      ),
                    );
                  } else {
                    // Display an error if credentials do not match
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid username or password'),
                        backgroundColor: ColorsManager.errorColor,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.buttonColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4,
                  shadowColor: ColorsManager.dropShadowColor,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsManager.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
