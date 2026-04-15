import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Opaque editorial camera look
      body: Stack(
        fit: StackFit.expand,
        children: [
          // SIMULATED CAMERA VIEW
          Container(
            color: const Color(0xFF1E1E1E),
            child: const Center(
              child: Text(
                'Lente',
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 10,
                  fontFamily: 'Inter',
                  letterSpacing: 4,
                ),
              ),
            ),
          ),

          // Subtle overlays
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 140,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Header
          Positioned(
            top: 60,
            left: 32,
            right: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'CERRAR',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const Text(
                  'ROSTRO EN LUZ NATURAL',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white54,
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Framing brackets (no more thick ovals)
          Center(
            child: SizedBox(
              width: 250,
              height: 350,
              child: Stack(
                children: const [
                  _CornerBracket(alignment: Alignment.topLeft),
                  _CornerBracket(alignment: Alignment.topRight),
                  _CornerBracket(alignment: Alignment.bottomLeft),
                  _CornerBracket(alignment: Alignment.bottomRight),
                ],
              ),
            ),
          ),

          // Controls
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/gallery'),
                  child: const Text(
                    'GALERÍA',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/analysis'),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'GIRAR',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final Alignment alignment;
  const _CornerBracket({required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0 ? const BorderSide(color: Colors.white54, width: 1) : BorderSide.none,
            bottom: alignment.y > 0 ? const BorderSide(color: Colors.white54, width: 1) : BorderSide.none,
            left: alignment.x < 0 ? const BorderSide(color: Colors.white54, width: 1) : BorderSide.none,
            right: alignment.x > 0 ? const BorderSide(color: Colors.white54, width: 1) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
