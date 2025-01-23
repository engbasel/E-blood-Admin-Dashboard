import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:flutter/material.dart';

Widget buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: ColorsManager.primaryColor),
    title: Text(title, style: const TextStyle(fontSize: 16)),
    onTap: onTap,
  );
}
