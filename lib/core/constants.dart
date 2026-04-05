import 'package:flutter/material.dart';

class AppColors {
  // Acento (Primario)
  static const Color primaryAccent = Color(0xFFC2547A);
  
  // Fondo Suave (Gradientes)
  static const Color gradientPink = Color(0xFFFDE8F0);
  static const Color gradientLavender = Color(0xFFE8E0F5);
  static const Color gradientBlue = Color(0xFFE0EEFF);
  
  // Glassmorphism y UI
  static const Color whiteGlassmorphism = Color(0x99FFFFFF); // Blanco con 60% opacidad
  static const Color borderGlassmorphism = Color(0x66FFFFFF); // Blanco con 40% opacidad
  static const Color shadowGlow = Color(0x4DFDE8F0); // Sombra rosa suave (30% opacidad aprox)
  
  // Gradiente lineal reusable
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      gradientPink,
      gradientLavender,
      gradientBlue,
    ],
  );
}

class AppConstants {
  // Radios de Borde (Corner Radius)
  static const double cardRadius = 24.0;
  static const double cardRadiusLarge = 32.0;
  static const double pillRadius = 50.0;
  
  static BorderRadius defaultCardRadius = BorderRadius.circular(cardRadius);
  static BorderRadius largeCardRadius = BorderRadius.circular(cardRadiusLarge);
  static BorderRadius pillBorderRadius = BorderRadius.circular(pillRadius);
}
