import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/services/gemini_service.dart';
import '../../data/repositories/colorimetry_repository.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentStepIndex = 0;
  String? _imagePath;
  bool _isProcessing = true;

  final List<String> _steps = [
    'CALIBRANDO LUZ',
    'DETECTANDO SUBTONO',
    'EVALUANDO CONTRASTE',
    'SINTETIZANDO PALETA',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        if (!mounted) return;
        final newIndex = (_controller.value * _steps.length).floor().clamp(0, _steps.length - 1);
        if (newIndex != _currentStepIndex) {
          setState(() {
            _currentStepIndex = newIndex;
          });
        }
      });
      
    // Iniciamos la animación y el procesamiento
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processImageWithGemini();
    });
  }

  Future<void> _processImageWithGemini() async {
    try {
      final path = ModalRoute.of(context)!.settings.arguments as String?;
      if (path == null) throw Exception("No image path provided");
      
      setState(() => _imagePath = path);

      final fileBytes = await File(path).readAsBytes();
      
      final geminiService = GeminiService();
      final colorimetryRepo = ColorimetryRepository();

      // Llamada real a IA
      final resultModel = await geminiService.analyzeColorimetry(fileBytes, path);
      
      // Guardado real a base de datos
      final savedId = await colorimetryRepo.saveResult(resultModel);

      // Esperar a que la animacion termine (minimo 4 segs para UX premium)
      while (_controller.isAnimating) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/analysis_results',
          arguments: savedId, // Pasamos el ID real de la BD
        );
      }
    } catch (e) {
      debugPrint("Error al procesar con Gemini: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en el análisis IA: $e')),
        );
        Navigator.pop(context); // Regresar si falla
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Stack(
          children: [
            // Círculo animado minimalista
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(200, 200),
                    painter: _MinimalArcPainter(
                      progress: _controller.value,
                      color: Colors.black87,
                    ),
                  );
                },
              ),
            ),
            
            // Textos cambiantes
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _steps[_currentStepIndex],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black87,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0,
                    ),
                  ),
                ],
              ),
            ),

            // Botón de cancelar
            Positioned(
              left: 32,
              top: 20,
              child: GestureDetector(
                onTap: () {
                  _controller.stop();
                  Navigator.pop(context);
                },
                child: const Text(
                  'CANCELAR',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MinimalArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _MinimalArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final bgPaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius, bgPaint);

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.square;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MinimalArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
