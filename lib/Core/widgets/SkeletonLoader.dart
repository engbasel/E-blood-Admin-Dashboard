import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      containersColor: Colors.white,
      enabled: true,
      enableSwitchAnimation: true,
      child: ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: const ListTile(
              leading:
                  Skeletonizer(enabled: true, child: Icon(Icons.bloodtype)),
              title: Skeletonizer(
                  enabled: true,
                  child: SizedBox(height: 16, width: double.infinity)),
              subtitle: Skeletonizer(
                  enabled: true,
                  child: SizedBox(height: 12, width: double.infinity)),
            ),
          );
        },
      ),
    );
  }
}
