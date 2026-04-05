import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Configuración Base de Color
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryAccent,
        primary: AppColors.primaryAccent,
        brightness: Brightness.light, 
      ),
      scaffoldBackgroundColor: Colors.transparent,
      useMaterial3: true,
      
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        // Headings con Playfair Display
        displayLarge: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.bold, color: Colors.black87),
        displayMedium: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.bold, color: Colors.black87),
        displaySmall: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.w600, color: Colors.black87),
        headlineLarge: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.w600, color: Colors.black87),
        headlineMedium: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.w600, color: Colors.black87),
        headlineSmall: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.w600, color: Colors.black87),
        titleLarge: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.w600, color: Colors.black87),
        
        // Cuerpos de texto asumen defecto (Inter)
        bodyLarge: TextStyle(fontFamily: 'Inter', color: Colors.black87),
        bodyMedium: TextStyle(fontFamily: 'Inter', color: Colors.black87),
        bodySmall: TextStyle(fontFamily: 'Inter', color: Colors.black54),
        labelLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
      ),
      
      // Estilo de Componentes
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0, // Evita que se oscurezca al hacer scroll
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontSize: 20,
        ),
      ),
      
      // Botón Primario y Pastillas (Pills)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.shadowGlow,
          shape: RoundedRectangleBorder(
            borderRadius: AppConstants.pillBorderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'Inter'),
        ),
      ),
      
      // Entradas de texto (Inputs y Forms)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.whiteGlassmorphism,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: AppConstants.pillBorderRadius,
          borderSide: const BorderSide(color: AppColors.borderGlassmorphism),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppConstants.pillBorderRadius,
          borderSide: const BorderSide(color: AppColors.borderGlassmorphism),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppConstants.pillBorderRadius,
          borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2),
        ),
      ),
      
      // Tarjetas Glassmorphism
      cardTheme: CardThemeData(
        color: AppColors.whiteGlassmorphism,
        elevation: 8,
        shadowColor: AppColors.shadowGlow,
        shape: RoundedRectangleBorder(
          borderRadius: AppConstants.defaultCardRadius,
          side: const BorderSide(color: AppColors.borderGlassmorphism),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
