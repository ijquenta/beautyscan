import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class BeautyBackground extends StatelessWidget {
  final Widget child;

  const BeautyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.beigeFondo, // Tono unificador
      child: Stack(
        children: [
          // Brillo cálido superior (Rosa Piel)
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.rosaPiel.withValues(alpha: 0.6),
              ),
            ),
          ),

          // Brillo suave inferior (Crema Suave)
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cremaSuave.withValues(alpha: 0.5),
              ),
            ),
          ),

          // Desenfoque para integrar los brillos con el fondo beige
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Contenido principal
          child,
        ],
      ),
    );
  }
}
