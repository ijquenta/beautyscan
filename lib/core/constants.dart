import 'package:flutter/material.dart';

class AppColors {
  // Nueva Paleta de Colores
  static const Color beigeFondo = Color(0xFFE5D3C5);
  static const Color blancoOffWhite = Color(0xFFFFFFFF);
  static const Color negroCarbon = Color(0xFF1A1A1A);
  static const Color cremaSuave = Color(0xFFF9F1EA);
  static const Color rosaPiel = Color(0xFFF2D5C4);
  static const Color grisCalido = Color(0xFF8C8279);

  // Mapeos y Variables Antiguas para mantener compatibilidad
  static const Color primaryAccent = negroCarbon;
  static const Color secondaryBackground = cremaSuave;

  // Glassmorphism y UI
  static const Color whiteGlassmorphism = Color(0x99FFFFFF); // Blanco con 60% opacidad
  static const Color borderGlassmorphism = Color(0x66FFFFFF); // Blanco con 40% opacidad
  static const Color shadowGlow = Color(0x331A1A1A); // Sombra suave oscura
  
  // Gradiente lineal para unificar el fondo cálido (Rosa Piel a Beige)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      beigeFondo,
      cremaSuave,
      rosaPiel,
    ],
  );
}

class AppConstants {
  // Radios de Borde (Corner Radius)
  static const double cardRadius = 24.0;
  static const double cardRadiusLarge = 32.0;
  static const double pillRadius = 50.0;
  
  static const BorderRadius defaultCardRadius = BorderRadius.all(Radius.circular(cardRadius));
  static const BorderRadius largeCardRadius = BorderRadius.all(Radius.circular(cardRadiusLarge));
  static const BorderRadius pillBorderRadius = BorderRadius.all(Radius.circular(pillRadius));
}
