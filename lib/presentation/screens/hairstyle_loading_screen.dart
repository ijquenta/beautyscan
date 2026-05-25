import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/atoms/beauty_background.dart';
import '../../domain/models/hairstyle_model.dart';
import '../../data/services/gemini_service.dart';
import '../../domain/models/colorimetry_result_model.dart';

class HairstyleLoadingScreen extends StatefulWidget {
  const HairstyleLoadingScreen({super.key});

  @override
  State<HairstyleLoadingScreen> createState() => _HairstyleLoadingScreenState();
}

class _HairstyleLoadingScreenState extends State<HairstyleLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _scannerController;
  late AnimationController _pulseController;
  final GeminiService _geminiService = GeminiService();

  final List<_ProcessingStep> _steps = [
    _ProcessingStep(label: 'CARGANDO MODELO IA', done: true),
    _ProcessingStep(label: 'ANALIZANDO ESTRUCTURA', done: true),
    _ProcessingStep(label: 'SINTETIZANDO CABELLO', done: false),
    _ProcessingStep(label: 'REFINADO EDITORIAL', done: false),
  ];

  @override
  void initState() {
    super.initState();
    // Animation for the sweeping scanner line
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Subtle pulse for the background and text
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

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
      final ColorimetryResultModel? colorimetry = args['colorimetry'] as ColorimetryResultModel?;
      final newPath = await _geminiService.generateHairstyle(
        originalPhotoPath,
        selectedStyle,
        colorimetry: colorimetry,
      );
      final end = DateTime.now();

      if (end.difference(start).inSeconds < 2) {
        await Future.delayed(const Duration(seconds: 2));
      }

      if (mounted && newPath != null) {
        HapticFeedback.lightImpact();
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
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al conectar con Nano Banana: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final style = args?['style'] as HairstyleModel?;
    final photoPath = args?['photoPath'] as String?;
    
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image with dark overlay
            if (photoPath != null)
              Image.file(
                File(photoPath),
                fit: BoxFit.cover,
              )
            else
              Container(color: Colors.black87),
              
            // Heavy glassmorphic/darkening overlay
            Container(
              color: Colors.black.withValues(alpha: 0.75),
            ),

            // Scanning Effect Overlay
            if (photoPath != null)
              AnimatedBuilder(
                animation: _scannerController,
                builder: (context, child) {
                  return ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _scannerController.value,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(photoPath)),
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(
                              Colors.white12,
                              BlendMode.lighten,
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                )
                              ],
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Bottom glass sheet for steps and text
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Description
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: 0.7 + (_pulseController.value * 0.3),
                          child: const Text(
                            'Sintetizando.',
                            style: TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -1.0,
                              height: 1.0,
                            ),
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Aplicando el estilo ${(style?.name.replaceAll('\n', ' ') ?? '')} con alta precisión arquitectónica.',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white70,
                        height: 1.6,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Steps
                    ..._steps.asMap().entries.map((entry) {
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
                                          color: Colors.white, fontSize: 12))
                                  : isActive
                                      ? const SizedBox(
                                          width: 10,
                                          height: 10,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.5,
                                            color: Colors.white,
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
                                    ? Colors.white
                                    : Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
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
