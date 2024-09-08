import 'package:flutter/material.dart';

class AppTheme {
  // Define the Purple and Pink Theme
  static ThemeData purplePinkTheme() {
    return ThemeData(
      primaryColor: Colors.red[700],  // Vibrant purple primary color
      hintColor: Colors.pinkAccent[400],  // Bright pink accent color
      scaffoldBackgroundColor: Colors.white, // White background for clarity
      appBarTheme: AppBarTheme(
        color: Colors.red[300], // Vibrant purple AppBar
        titleTextStyle: const TextStyle(
          color: Colors.white, 
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      cardColor: Colors.pink[100], // Light purple for cards
  elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.red[300], // Set button color to white
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Set text color to black for contrast
  ),
),
      textTheme:const TextTheme(
        titleLarge: TextStyle(
          color: Colors.black, 
          fontSize: 18, 
          fontWeight: FontWeight.bold
        ),
        titleMedium: TextStyle(
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
        ),
      ),
      iconTheme:const IconThemeData(
        color: Colors.red,
        size: 30,
      ),
    );
  }
}
