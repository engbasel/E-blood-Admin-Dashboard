import 'dart:ui';
import 'package:adminbloodv2/Core/manger/ColorsManager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adminbloodv2/Core/widgets/CoustomCircularProgressIndicator.dart';

Widget buildSummarySection(
  BuildContext context,
  String title,
  String collection,
  VoidCallback onTap, {
  String? status, // Optional status parameter
}) {
  return GestureDetector(
    onTap: onTap,
    child: StreamBuilder<QuerySnapshot>(
      stream: status != null
          ? FirebaseFirestore.instance
              .collection(collection)
              .where('status',
                  isEqualTo: status) // Filter by status if provided
              .snapshots()
          : FirebaseFirestore.instance
              .collection(collection)
              .snapshots(), // No filter
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CoustomCircularProgressIndicator());
        }

        final totalCount = snapshot.data!.size;

        return Container(
          width: 150, // Fixed width for each summary section
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: ColorsManager.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '$totalCount',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
