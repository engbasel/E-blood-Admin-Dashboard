import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:flutter/material.dart';

Widget buildRequestListTile(String title, String subtitle) {
  return ListTile(
    leading: const Icon(Icons.person, color: ColorsManager.primaryColor),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      subtitle,
      style: const TextStyle(color: ColorsManager.buttonColor),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.check, color: ColorsManager.successColor),
          onPressed: () {
            // Approve action
          },
        ),
        IconButton(
          icon: const Icon(Icons.close, color: ColorsManager.errorColor),
          onPressed: () {
            // Reject action
          },
        ),
      ],
    ),
  );
}
