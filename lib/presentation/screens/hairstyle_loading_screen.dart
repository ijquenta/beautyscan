import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/hairstyle_model.dart';
import '../../domain/models/hairstyle_result_model.dart';
import '../../data/services/gemini_service.dart';
import '../../data/repositories/hairstyle_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/models/colorimetry_result_model.dart';

class HairstyleLoadingScreen extends StatefulWidget {
  const HairstyleLoadingScreen({super.key});

  @override
  State<HairstyleLoadingScreen> createState() => _HairstyleLoadingScreenState();
}

class _HairstyleLoadingScreenState extends State<HairstyleLoadingScreen> {
  final GeminiService _geminiService = GeminiService();
  String _statusText = 'Preparando...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
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
          final user = await UserRepository().getCurrentUser();
          if (user != null) {
            await HairstyleRepository().saveResult(HairstyleResultModel(
              userId: user.id!,
              originalPhotoPath: originalPhotoPath,
              hairstyleName: selectedStyle.name.replaceAll('\n', ' '),
              resultImageUrl: newPath,
              createdAt: DateTime.now().toIso8601String(),
            ));
          }
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
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final style = args?['style'] as HairstyleModel?;
    final photoPath = args?['photoPath'] as String?;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (photoPath != null)
            Positioned.fill(
              child: Image.file(
                File(photoPath),
                fit: BoxFit.cover,
              ),
            ),

          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.6)),
          ),

          Column(
            children: [
              const Spacer(flex: 3),
              const Text(
                'Creando tu look',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Aplicando ${style?.name.replaceAll('\n', ' ') ?? 'estilo'}',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.white60),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Container(
                        height: 3,
                        width: double.infinity,
                        color: Colors.white.withValues(alpha: 0.15),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progress,
                          child: Container(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _statusText,
                        key: ValueKey(_statusText),
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.white.withValues(alpha: 0.5)),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),

          Positioned(
            left: 16,
            top: MediaQuery.of(context).padding.top + 8,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.close_rounded, size: 22, color: Colors.white.withValues(alpha: 0.7)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
