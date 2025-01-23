import 'package:flutter/material.dart';

Widget buildSummaryCardsRow(List<Widget> cards) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: cards
          .map((card) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: card,
              ))
          .toList(),
    ),
  );
}
