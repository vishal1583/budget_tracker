import 'package:flutter/material.dart';

class BudgetTheme {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF2E5CB8);      // Professional, trustworthy main color
  static const Color secondaryTeal = Color(0xFF20B2AA);    // Fresh, financial growth
  static const Color successGreen = Color(0xFF2E7D32);     // Deeper green for income - more professional
  static const Color errorRed = Color(0xFFD32F2F);         // Deeper red for expenses - less aggressive
  
  // Neutral Colors
  static const Color lightGray = Color(0xFFF8F9FA);        // Light mode background - easier on eyes
  static const Color darkGray = Color(0xFF1A1A1A);         // Dark mode background
  static const Color mutedBlue = Color(0xFFE3F2FD);        // Subtle highlight color
  static const Color textDark = Color(0xFF2C3E50);         // Primary text color - softer than pure black

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: lightGray,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0, // Modern flat design
    ),
    colorScheme: ColorScheme.light(
      primary: primaryBlue,
      secondary: secondaryTeal,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textDark,
      error: errorRed,
      onError: Colors.white,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.white,
      selectedColor: primaryBlue,
      textColor: textDark,
      iconColor: primaryBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: mutedBlue, width: 1),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryBlue), // Page titles
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black), // Section headers
      bodyLarge: TextStyle(fontSize: 18, color: Colors.black), // Main text
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black), // Secondary text
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: secondaryTeal), // Button text
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: secondaryTeal),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
    ),
    
    
    iconTheme: IconThemeData(color: primaryBlue, size: 24), // Default icon color
    primaryIconTheme: IconThemeData(color: Colors.white), // AppBar & Primary Icons

    
    dividerTheme: DividerThemeData(
      color: secondaryTeal,
      thickness: 1.5,
      space: 16,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryBlue,
      contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
      actionTextColor: secondaryTeal,
      behavior: SnackBarBehavior.floating,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        // textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        elevation: 4,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: darkGray,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: ColorScheme.dark(
      primary: primaryBlue,
      secondary: secondaryTeal,
      surface: Color(0xFF242424),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      error: errorRed,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: secondaryTeal),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: secondaryTeal),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: secondaryTeal),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
    ),

   
    iconTheme: IconThemeData(color: secondaryTeal, size: 24), 
    primaryIconTheme: IconThemeData(color: Colors.white),

    
    dividerTheme: DividerThemeData(
      color: secondaryTeal,
      thickness: 1.5,
      space: 16,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryBlue,
      contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
      actionTextColor: secondaryTeal,
      behavior: SnackBarBehavior.floating,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        elevation: 4,
      ),
    ),
  );
}
