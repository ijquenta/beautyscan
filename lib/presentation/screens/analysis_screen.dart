import 'package:flutter/material.dart';
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
    _AnalysisStep(label: 'DETECTANDO PUNTOS FACIALES', done: true),
    _AnalysisStep(label: 'ANALIZANDO TONO DE PIEL', done: true),
    _AnalysisStep(label: 'CALCULANDO COLORIMETRÍA', done: false),
    _AnalysisStep(label: 'GENERANDO RECOMENDACIONES', done: false),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
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
            child: const Padding(
              padding: EdgeInsets.only(left: 32, top: 20),
              child: Text(
                'CANCELAR',
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
          leadingWidth: 150,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              const Text(
                'El Análisis.',
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
                'Estamos procesando tu rostro.\nLa espera será breve.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.black45,
                  height: 1.5,
                  fontSize: 14,
                ),
              ),

              const Spacer(flex: 2),

              // Animacion central minimalista
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12, width: 1.5),
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black26, width: 1),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            color: Colors.black87,
                            strokeWidth: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Pasos del análisis (Tipográficos)
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
                                ? const Text('—', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))
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
                              letterSpacing: 2.0,
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

              // DEMO ACTION
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/analysis_results'),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: const Center(
                    child: Text(
                      'VER RESULTADOS (DEMO)',
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

class _AnalysisStep {
  final String label;
  final bool done;
  const _AnalysisStep({required this.label, required this.done});
}
