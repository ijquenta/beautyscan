import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants.dart';
import '../../domain/models/hairstyle_model.dart';
import '../../data/services/gemini_service.dart';
import '../../domain/models/colorimetry_result_model.dart';

class HairstyleLoadingScreen extends StatefulWidget {
  const HairstyleLoadingScreen({super.key});

  @override
  State<HairstyleLoadingScreen> createState() => _HairstyleLoadingScreenState();
}

class _HairstyleLoadingScreenState extends State<HairstyleLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final GeminiService _geminiService = GeminiService();

  String _statusText = 'Cargando modelo IA';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
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
      _statusText = 'Sintetizando cabello';
      _progress = 0.4;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _statusText = 'Generando con IA';
          _progress = 0.7;
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
        setState(() => _progress = 1.0);
        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) {
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
        }
      } else if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: falló la generación de imagen.')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final style = args?['style'] as HairstyleModel?;
    final photoPath = args?['photoPath'] as String?;

    return Scaffold(
      backgroundColor: AppColors.beigeFondo,
      body: SafeArea(
        child: Stack(
          children: [
            if (photoPath != null)
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    image: DecorationImage(
                      image: FileImage(File(photoPath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),

            Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Opacity(
                    opacity: 0.7 + (_pulseController.value * 0.3),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Icon(Icons.auto_awesome_rounded, size: 36, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(32, 48, 32, 56),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      Colors.black.withValues(alpha: 0.85),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: 0.7 + (_pulseController.value * 0.3),
                          child: const Text(
                            'Creando tu look',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.8, height: 1.1),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aplicando ${style?.name.replaceAll('\n', ' ') ?? 'estilo'} con IA.',
                      style: const TextStyle(fontFamily: 'Poppins', color: Colors.white60, height: 1.4, fontSize: 13),
                    ),
                    const SizedBox(height: 32),
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Container(
                            height: 3,
                            width: double.infinity,
                            color: Colors.white.withValues(alpha: 0.15),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progress + ((1 - _progress) * _pulseController.value * 0.3),
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        _statusText,
                        key: ValueKey(_statusText),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.6),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 32,
              top: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.close_rounded, size: 18, color: Colors.white.withValues(alpha: 0.6)),
                    const SizedBox(width: 6),
                    Text('Cancelar', style: TextStyle(fontFamily: 'Poppins', color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
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
