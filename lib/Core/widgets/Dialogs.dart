import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;

  const CustomDialog({required this.title, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK')),
      ],
    );
  }
}
