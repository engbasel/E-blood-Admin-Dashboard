import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:flutter/material.dart';

class CoustomCircularProgressIndicator extends StatelessWidget {
  const CoustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 6.0, // Thicker indicator for a bolder appearance
        valueColor: const AlwaysStoppedAnimation<Color>(
          ColorsManager.backgroundColor,
        ), // Custom color from ColorsManager
        backgroundColor: ColorsManager.buttonColor
            .withOpacity(0.3), // Use a softer background color
      ),
    );
  }
}
