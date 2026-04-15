import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class HairstyleProcessingScreen extends StatefulWidget {
  const HairstyleProcessingScreen({super.key});

  @override
  State<HairstyleProcessingScreen> createState() =>
      _HairstyleProcessingScreenState();
}

class _HairstyleProcessingScreenState extends State<HairstyleProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateController;

  final List<_ProcessingStep> _steps = [
    _ProcessingStep(label: 'CARGANDO MODELO', done: true),
    _ProcessingStep(label: 'ANALIZANDO ESTRUCTURA', done: true),
    _ProcessingStep(label: 'SINTETIZANDO CABELLO', done: false),
    _ProcessingStep(label: 'REFINADO EDITORIAL', done: false),
  ];

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.only(left: 32, top: 20),
              child: Text(
                'VOLVER',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          leadingWidth: 100,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              const Text(
                'Procesando.',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: -1.0,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aplicando el nuevo estilo con alta\nprecisión arquitectónica.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.black54,
                  height: 1.6,
                  fontSize: 14,
                ),
              ),

              const Spacer(flex: 2),

              // Animación geométrica mínima
              Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: _rotateController,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CustomPaint(painter: _MinimalArcPainter()),
                    ),
                  ),
                  const Text(
                    'IA',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 3),

              // Pasos (texto puro)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    final isActive = !step.done && (index == 0 || _steps[index - 1].done);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            child: step.done
                                ? const Text('✓', style: TextStyle(color: Colors.black87, fontSize: 12))
                                : isActive
                                    ? const SizedBox(
                                        width: 10,
                                        height: 10,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                          color: Colors.black87,
                                        ),
                                      )
                                    : const SizedBox(),
                          ),
                          Text(
                            step.label,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              letterSpacing: 2.5,
                              fontWeight: step.done || isActive ? FontWeight.w600 : FontWeight.w400,
                              color: step.done || isActive ? Colors.black87 : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const Spacer(flex: 2),

              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/hairstyle_display'),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: const Center(
                    child: Text(
                      'VER RESULTADO (DEMO)',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessingStep {
  final String label;
  final bool done;
  const _ProcessingStep({required this.label, required this.done});
}

class _MinimalArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      3.14, // Half circle
      false,
      paint,
    );
    
    final paintLight = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
      
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      3.14,
      3.14, 
      false,
      paintLight,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
