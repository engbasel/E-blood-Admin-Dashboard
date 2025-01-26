import 'package:flutter/material.dart';

class CoustomDonorsDetailsSection extends StatelessWidget {
  const CoustomDonorsDetailsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Fixed height for the horizontal list
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [],
      ),
    );
  }
}
