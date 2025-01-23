import 'package:flutter/material.dart';

class ColorsManager {
  // Existing Colors (Primary, Secondary, etc.)
  static const Color primaryColor = Color(0xff630909); // Dark Red
  static const Color buttonColor = Color(0xff800000); // Maroon

  // Feedback Colors
  static const Color successColor = Color(0xFF4CAF50); // Green (Success)
  static const Color warningColor = Color(0xFFFFC107); // Amber (Warning)
  static const Color errorColor = Color(0xFFF44336); // Red (Error)

  // Accent and Secondary Colors
  static const Color secondaryColor = Color(0xFF03DAC6); // Teal Accent
  static const Color highlightColor =
      Color.fromARGB(255, 219, 92, 92); // Snackbar Highlight

  // Background Colors
  static const Color backgroundColor = primaryColor; // Dark Red
  static const Color whiteBackgroundColor = Colors.white;

  // Text Colors
  static const Color primaryTextColor = Colors.black87;
  static const Color secondaryTextColor = Colors.black54;
  static const Color splashDescriptionColor = Colors.grey;

  // Neutral Colors
  static const Color dropShadowColor =
      Color.fromARGB(255, 102, 89, 89); // Shadow for Elements
}
