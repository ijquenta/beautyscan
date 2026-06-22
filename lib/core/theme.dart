import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Configuración Base de Color
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.cremaSuave,
        primary: AppColors.negroCarbon,
        brightness: Brightness.light,
      ),
      useMaterial3: true,

      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        // Headings con Playfair Display
        displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: AppColors.negroCarbon,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: AppColors.negroCarbon,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: AppColors.negroCarbon,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: AppColors.negroCarbon,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: AppColors.negroCarbon,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: AppColors.negroCarbon,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: AppColors.negroCarbon,
        ),

        // Cuerpos de texto
        bodyLarge: TextStyle(fontFamily: 'Poppins', color: AppColors.negroCarbon),
        bodyMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.negroCarbon),
        bodySmall: TextStyle(fontFamily: 'Poppins', color: AppColors.grisCalido),
        labelLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      ),

      // Estilo de Componentes
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0, // Evita que se oscurezca al hacer scroll
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.negroCarbon),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: AppColors.negroCarbon,
          fontSize: 20,
        ),
      ),

      // Botón Primario y Pastillas (Pills)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.negroCarbon,
          foregroundColor: AppColors.blancoOffWhite,
          elevation: 4,
          shadowColor: AppColors.shadowGlow,
          shape: RoundedRectangleBorder(
            borderRadius: AppConstants.pillBorderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
      ),

      // Entradas de texto (Inputs y Forms)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.blancoOffWhite.withValues(alpha: 0.9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
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
          borderSide: const BorderSide(
            color: AppColors.negroCarbon,
            width: 2,
          ),
        ),
      ),

      // Tarjetas Glassmorphism
      cardTheme: CardThemeData(
        color: AppColors.blancoOffWhite.withValues(alpha: 0.95),
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
