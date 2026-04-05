import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class BeautyBackground extends StatelessWidget {
  final Widget child;

  const BeautyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          // Círculo 2 (Inferior Centro-Izquierda)
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 400, // Doble del tamaño
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Usamos un púrpura más saturado base, el blur lo hará luz pastel.
                color: AppColors.primaryAccent.withValues(alpha: 0.4),
              ),
            ),
          ),

          // Círculo 1 (Superior Derecha)
          Positioned(
            top: -50,
            right: -80,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Usamos tu color de Acento primario, al difuminarse quedará el rosa pastel perfecto.
                color: AppColors.primaryAccent.withValues(alpha: 0.4),
              ),
            ),
          ),

          // Capa de desenfoque Glassmorphism
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 80.0,
                sigmaY: 80.0,
              ), // Fuerte difuminado para suavizar los colores fuertes
              child: Container(
                color: Colors
                    .transparent, // Queremos pureza de color, sin velo extra
              ),
            ),
          ),

          // Renderiza el contenido principal en la última capa
          // NOTA: Si `child` es un Scaffold, asegúrate de que el Scaffold tenga
          // `backgroundColor: Colors.transparent` para que este fondo se vea.
          child,
        ],
      ),
    );
  }
}
