import 'dart:io';
import 'package:flutter/material.dart';
import '../components/organisms/before_after_slider.dart';
import '../../domain/models/hairstyle_model.dart';

class HairstyleDisplayScreen extends StatefulWidget {
  const HairstyleDisplayScreen({super.key});

  @override
  State<HairstyleDisplayScreen> createState() => _HairstyleDisplayScreenState();
}

class _HairstyleDisplayScreenState extends State<HairstyleDisplayScreen> {
  String? _originalPhotoPath;
  String? _photoPath; // Nuevo path generado
  HairstyleModel? _style;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _style = args['style'] as HairstyleModel?;
      _photoPath = args['photoPath'] as String?;
      _originalPhotoPath = args['originalPhotoPath'] as String?;
    } else if (args is HairstyleModel) {
      _style = args;
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final photoPath = _photoPath;
    final originalPath = _originalPhotoPath;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fullscreen Image / Slider
          BeforeAfterSlider(
            beforeImage: originalPath != null
                ? FileImage(File(originalPath)) as ImageProvider
                : const NetworkImage(
                    'https://images.unsplash.com/photo-1549471013-3364d7ce4668?auto=format&fit=crop&q=80&w=800',
                  ),
            afterImage: photoPath != null
                ? FileImage(File(photoPath)) as ImageProvider
                : const NetworkImage(
                    'https://images.unsplash.com/photo-1580618672591-eb180b1a973f?auto=format&fit=crop&q=80&w=800',
                  ),
          ),

          // Top Gradient overlay for AppBar readability
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Custom Transparent AppBar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Text(
                  'VOLVER',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Glassmorphic Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESULTADO',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3.0,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    style != null ? style.name.replaceAll('\n', ' ') : 'Simulación.',
                    style: const TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -1.0,
                      height: 1.0,
                    ),
                  ),
                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/hairstyle_detail',
                            arguments: style,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white38),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                'DETALLES',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                'GUARDAR',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  const _MetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 8,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
