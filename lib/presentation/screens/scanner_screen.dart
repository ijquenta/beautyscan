import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.whiteGlassmorphism,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white60, width: 1),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.black87, size: 20),
            ),
          ),
          title: Text(
            'Escanear rostro',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              children: [
                // Instruccion
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlassmorphism,
                    borderRadius: AppConstants.pillBorderRadius,
                    border: Border.all(color: Colors.white60, width: 1),
                  ),
                  child: const Text(
                    'Centra tu rostro dentro del óvalo y mantente quieta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Visor de cámara
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppConstants.largeCardRadius,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Fondo placeholder de cámara
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFFD4C8F0).withValues(alpha: 0.5),
                                const Color(0xFFFDE8F0).withValues(alpha: 0.5),
                              ],
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Container(color: Colors.transparent),
                          ),
                        ),

                        // Overlay oscuro en bordes
                        Positioned.fill(
                          child: CustomPaint(painter: _FaceOvalPainter()),
                        ),

                        // Esquinas del marco
                        ..._buildCorners(),

                        // Texto central
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 80),
                              Text(
                                'Cámara no disponible\nen modo demo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: Colors.black38.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Indicador de deteccion
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4CAF50),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Listo',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Controles inferiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Boton galeria
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/gallery'),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.whiteGlassmorphism,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white70, width: 1),
                        ),
                        child: const Center(
                          child: Text(
                            'GAL',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Boton captura principal
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/analysis'),
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC2547A), Color(0xFFD4729A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryAccent.withValues(alpha: 0.45),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                    ),

                    // Boton voltear camara
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.whiteGlassmorphism,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white70, width: 1),
                      ),
                      child: const Center(
                        child: Text(
                          'FLIP',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCorners() {
    const double size = 24;
    const double strokeWidth = 3;
    const Color color = AppColors.primaryAccent;
    const double padding = 52.0;

    return [
      // Top-left
      Positioned(
        top: padding,
        left: padding,
        child: CustomPaint(
          size: const Size(size, size),
          painter: _CornerPainter(position: _CornerPosition.topLeft, color: color, strokeWidth: strokeWidth),
        ),
      ),
      // Top-right
      Positioned(
        top: padding,
        right: padding,
        child: CustomPaint(
          size: const Size(size, size),
          painter: _CornerPainter(position: _CornerPosition.topRight, color: color, strokeWidth: strokeWidth),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: padding,
        left: padding,
        child: CustomPaint(
          size: const Size(size, size),
          painter: _CornerPainter(position: _CornerPosition.bottomLeft, color: color, strokeWidth: strokeWidth),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: padding,
        right: padding,
        child: CustomPaint(
          size: const Size(size, size),
          painter: _CornerPainter(position: _CornerPosition.bottomRight, color: color, strokeWidth: strokeWidth),
        ),
      ),
    ];
  }
}

class _FaceOvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.18);
    final clearPaint = Paint()..blendMode = BlendMode.clear;

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // Fondo semitransparente
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // Oval del rostro
    final ovalRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.44),
      width: size.width * 0.62,
      height: size.height * 0.65,
    );
    canvas.drawOval(ovalRect, clearPaint);

    canvas.restore();

    // Borde del oval
    final borderPaint = Paint()
      ..color = AppColors.primaryAccent.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawOval(ovalRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum _CornerPosition { topLeft, topRight, bottomLeft, bottomRight }

class _CornerPainter extends CustomPainter {
  final _CornerPosition position;
  final Color color;
  final double strokeWidth;

  const _CornerPainter({
    required this.position,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    switch (position) {
      case _CornerPosition.topLeft:
        path.moveTo(size.width, 0);
        path.lineTo(0, 0);
        path.lineTo(0, size.height);
        break;
      case _CornerPosition.topRight:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height);
        break;
      case _CornerPosition.bottomLeft:
        path.moveTo(0, 0);
        path.lineTo(0, size.height);
        path.lineTo(size.width, size.height);
        break;
      case _CornerPosition.bottomRight:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
