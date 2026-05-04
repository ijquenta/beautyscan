import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';
import '../../domain/models/hairstyle_model.dart';
import '../../data/services/gemini_service.dart';

class HairstyleLoadingScreen extends StatefulWidget {
  const HairstyleLoadingScreen({super.key});

  @override
  State<HairstyleLoadingScreen> createState() => _HairstyleLoadingScreenState();
}

class _HairstyleLoadingScreenState extends State<HairstyleLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateController;
  final GeminiService _geminiService = GeminiService();

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

    // Trigger logic right after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGeneration();
    });
  }

  Future<void> _startGeneration() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null) return;
    
    final originalPhotoPath = args['photoPath'] as String?;
    final selectedStyle = args['style'] as HairstyleModel?;

    if (originalPhotoPath == null || selectedStyle == null) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Datos insuficientes para generar.')),
        );
      }
      return;
    }

    setState(() {
      _steps[2] = _ProcessingStep(label: 'SINTETIZANDO CABELLO', done: true);
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _steps[3] = _ProcessingStep(label: 'ENVIANDO A NANO BANANA', done: true);
        });
      }

      final start = DateTime.now();
      final newPath = await _geminiService.generateHairstyle(originalPhotoPath, selectedStyle);
      final end = DateTime.now();

      if (end.difference(start).inSeconds < 2) {
        await Future.delayed(const Duration(seconds: 1));
      }

      if (mounted && newPath != null) {
        Navigator.pushReplacementNamed(
          context,
          '/hairstyle_display',
          arguments: {
            'style': selectedStyle,
            'photoPath': newPath,
            'originalPhotoPath': originalPhotoPath,
          },
        );
      } else if (mounted) {
         Navigator.pop(context);
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Error: falló la generación de imagen en Nano Banana.')),
         );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Volver a selección
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al conectar con Nano Banana: \$e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tomar estilo de argumentos para nombre en UI si es posible
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final style = args?['style'] as HairstyleModel?;
    
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Spacer(flex: 1),
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
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Aplicando el estilo ' + (style?.name.replaceAll('\\n', ' ') ?? '') + ' con alta precisión arquitectónica.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.black54,
                    height: 1.6,
                    fontSize: 13,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Animación geométrica mínima
              RotationTransition(
                turns: _rotateController,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: CustomPaint(painter: _MinimalArcPainter()),
                ),
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
                    final isActive =
                        !step.done && (index == 0 || _steps[index - 1].done);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            child: step.done
                                ? const Text('✓',
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 12))
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

              const Spacer(flex: 2),
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
  _ProcessingStep({required this.label, required this.done});
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
      3.14,
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
