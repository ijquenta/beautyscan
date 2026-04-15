import 'package:flutter/material.dart';
import '../../core/constants.dart';
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
    _ProcessingStep(label: 'Cargando modelo de IA', done: true),
    _ProcessingStep(label: 'Segmentando el cabello', done: true),
    _ProcessingStep(label: 'Aplicando nuevo estilo', done: false),
    _ProcessingStep(label: 'Refinando detalles finales', done: false),
  ];

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
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
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.whiteGlassmorphism,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white60, width: 1),
              ),
              child: const Icon(Icons.close_rounded, color: Colors.black87, size: 20),
            ),
          ),
          title: Text(
            'Aplicando estilo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Animacion de procesamiento
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Anillo giratorio
                    RotationTransition(
                      turns: _rotateController,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryAccent.withValues(alpha: 0.15),
                            width: 2,
                          ),
                        ),
                        child: CustomPaint(painter: _ArcPainter()),
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryAccent.withValues(alpha: 0.08),
                      ),
                    ),
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C5CBF), Color(0xFFC2547A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C5CBF).withValues(alpha: 0.4),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'IA',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Text(
                  'La IA está trabajando',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Estamos simulando el peinado\nsobre tu foto con alta precisión',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.black45,
                    height: 1.5,
                  ),
                ),

                const Spacer(flex: 2),

                // Pasos
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlassmorphism,
                    borderRadius: AppConstants.largeCardRadius,
                    border: Border.all(color: Colors.white60, width: 1),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadowGlow, blurRadius: 16),
                    ],
                  ),
                  child: Column(
                    children: _steps.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      final isActive = !step.done &&
                          (index == 0 || _steps[index - 1].done);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: step.done
                                    ? const Color(0xFF7C5CBF)
                                    : isActive
                                        ? const Color(0xFF7C5CBF)
                                            .withValues(alpha: 0.15)
                                        : Colors.black.withValues(alpha: 0.06),
                              ),
                              child: Center(
                                child: step.done
                                    ? const Icon(Icons.check_rounded,
                                        color: Colors.white, size: 14)
                                    : isActive
                                        ? const SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Color(0xFF7C5CBF),
                                            ),
                                          )
                                        : Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black
                                                  .withValues(alpha: 0.2),
                                            ),
                                          ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              step.label,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: step.done || isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: step.done || isActive
                                    ? Colors.black87
                                    : Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const Spacer(flex: 3),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      '/hairstyle_display',
                    ),
                    child: const Text('Ver resultado (demo)'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
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

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryAccent.withValues(alpha: 0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -1.57,
      2.4,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
