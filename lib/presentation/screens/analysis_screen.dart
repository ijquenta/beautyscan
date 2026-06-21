import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/constants.dart';
import '../../data/services/gemini_service.dart';
import '../../data/repositories/colorimetry_repository.dart';
import '../components/atoms/beauty_background.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentStepIndex = 0;

  final List<String> _steps = [
    'Calibrando luz',
    'Detectando subtono',
    'Evaluando contraste',
    'Sintetizando paleta',
  ];

  final List<IconData> _stepIcons = [
    Icons.wb_sunny_outlined,
    Icons.palette_outlined,
    Icons.contrast_outlined,
    Icons.auto_awesome_outlined,
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

    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processImageWithGemini();
    });
  }

  Future<void> _processImageWithGemini() async {
    try {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args == null) throw Exception("No args provided");

      final tempPath = args['path'] as String;
      final clientName = args['clientName'] as String;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final permanentFile = await File(tempPath).copy('${appDir.path}/$fileName');
      final persistentPath = permanentFile.path;
      final fileBytes = await permanentFile.readAsBytes();

      final geminiService = GeminiService();
      final colorimetryRepo = ColorimetryRepository();

      final resultModel = await geminiService.analyzeColorimetry(fileBytes, persistentPath, clientName);

      final savedId = await colorimetryRepo.saveResult(resultModel);

      while (_controller.isAnimating) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/analysis_results',
          arguments: savedId,
        );
      }
    } catch (e) {
      debugPrint("Error al procesar con Gemini: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            content: Text('Error en el análisis IA: $e', style: const TextStyle(fontFamily: 'Poppins')),
          ),
        );
        Navigator.pop(context);
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
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(180, 180),
                      painter: _MinimalArcPainter(
                        progress: _controller.value,
                        color: AppColors.negroCarbon,
                      ),
                    );
                  },
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.negroCarbon.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(_stepIcons[_currentStepIndex], size: 24, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _steps[_currentStepIndex],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'Poppins', color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Análisis con IA en progreso',
                      style: TextStyle(fontFamily: 'Poppins', color: Colors.black.withValues(alpha: 0.3), fontSize: 11),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 32,
                top: 20,
                child: GestureDetector(
                  onTap: () {
                    _controller.stop();
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.close_rounded, size: 18, color: Colors.black.withValues(alpha: 0.4)),
                      const SizedBox(width: 6),
                      Text(
                        'Cancelar',
                        style: TextStyle(fontFamily: 'Poppins', color: Colors.black.withValues(alpha: 0.4), fontSize: 13),
                      ),
                    ],
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

class _MinimalArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _MinimalArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final bgPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, bgPaint);

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

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
