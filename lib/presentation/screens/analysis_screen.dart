import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<_AnalysisStep> _steps = [
    _AnalysisStep(label: 'Detectando puntos faciales', done: true),
    _AnalysisStep(label: 'Analizando tono de piel', done: true),
    _AnalysisStep(label: 'Calculando colorimetría', done: false),
    _AnalysisStep(label: 'Generando recomendaciones', done: false),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
            'Analizando',
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

                // Animacion central
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryAccent.withValues(alpha: 0.08),
                        ),
                      ),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryAccent.withValues(alpha: 0.14),
                        ),
                      ),
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC2547A), Color(0xFFD4729A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryAccent.withValues(alpha: 0.4),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Procesando tu análisis',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Por favor espera, esto solo\ntarda unos segundos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.black45,
                    height: 1.5,
                  ),
                ),

                const Spacer(flex: 2),

                // Pasos del análisis
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
                      final isActive = !step.done && (index == 0 || _steps[index - 1].done);
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
                                    ? AppColors.primaryAccent
                                    : isActive
                                        ? AppColors.primaryAccent.withValues(alpha: 0.15)
                                        : Colors.black.withValues(alpha: 0.06),
                              ),
                              child: Center(
                                child: step.done
                                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                                    : isActive
                                        ? const SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.primaryAccent,
                                            ),
                                          )
                                        : Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black.withValues(alpha: 0.2),
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

                // Boton simulacion (mock)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      '/analysis_results',
                    ),
                    child: const Text('Ver resultados (demo)'),
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

class _AnalysisStep {
  final String label;
  final bool done;
  const _AnalysisStep({required this.label, required this.done});
}
