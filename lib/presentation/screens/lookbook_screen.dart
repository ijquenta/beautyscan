import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../../domain/models/hairstyle_result_model.dart';
import '../../data/services/gemini_service.dart';
import '../../data/repositories/hairstyle_repository.dart';
import '../../core/session_manager.dart';
import '../components/atoms/beauty_background.dart';
import '../../domain/models/hairstyle_model.dart';

class LookbookScreen extends StatefulWidget {
  const LookbookScreen({super.key});

  @override
  State<LookbookScreen> createState() => _LookbookScreenState();
}

class _LookbookScreenState extends State<LookbookScreen> {
  final GeminiService _geminiService = GeminiService();
  final HairstyleRepository _hairstyleRepo = HairstyleRepository();
  bool _isGenerating = true;
  bool _hasError = false;
  String? _photoPath;
  String? _collagePath;
  ColorimetryResultModel? _colorimetry;
  List<String> _quadrants = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_photoPath == null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _photoPath = args?['photoPath'] as String?;
      _colorimetry = args?['colorimetry'] as ColorimetryResultModel?;
      if (_photoPath != null) _generateCollage();
    }
  }

  Future<void> _generateCollage() async {
    setState(() {
      _isGenerating = true;
      _hasError = false;
      _quadrants = [];
    });
    try {
      final path = await _geminiService.generateHairstyleInfographic(
        _photoPath!,
        colorimetry: _colorimetry,
      );
      if (mounted && path != null) {
        _collagePath = path;
        await _splitIntoQuadrants(path);
        final userId = await SessionManager.getLoggedInUserId();
        if (userId != null) {
          final now = DateTime.now().toIso8601String();
          final personName = _colorimetry?.clientName ?? '';
          await _hairstyleRepo.saveResult(HairstyleResultModel(
            userId: userId,
            colorimetryResultId: _colorimetry?.id,
            originalPhotoPath: _photoPath!,
            hairstyleName: 'Collage de looks',
            resultImageUrl: path,
            createdAt: now,
            personName: personName,
          ));
          for (int i = 0; i < _quadrants.length; i++) {
            await _hairstyleRepo.saveResult(HairstyleResultModel(
              userId: userId,
              colorimetryResultId: _colorimetry?.id,
              originalPhotoPath: _photoPath!,
              hairstyleName: 'Look ${i + 1}',
              resultImageUrl: _quadrants[i],
              createdAt: now,
              personName: personName,
            ));
          }
        }
        if (mounted) {
          setState(() => _isGenerating = false);
        }
      } else if (mounted) {
        setState(() {
          _isGenerating = false;
          _hasError = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _splitIntoQuadrants(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final halfW = image.width ~/ 2;
    final halfH = image.height ~/ 2;
    final appDir = Directory(file.parent.path);

    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 2; col++) {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, halfW.toDouble(), halfH.toDouble()));
        canvas.drawImageRect(
          image,
          Rect.fromLTWH((col * halfW).toDouble(), (row * halfH).toDouble(), halfW.toDouble(), halfH.toDouble()),
          Rect.fromLTWH(0, 0, halfW.toDouble(), halfH.toDouble()),
          Paint(),
        );
        final picture = recorder.endRecording();
        final cropped = await picture.toImage(halfW, halfH);
        final byteData = await cropped.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          final cropPath = '${appDir.path}/quadrant_${row}_${col}_${DateTime.now().millisecondsSinceEpoch}.png';
          await File(cropPath).writeAsBytes(byteData.buffer.asUint8List());
          _quadrants.add(cropPath);
        }
      }
    }
    image.dispose();
  }

  @override
  void dispose() {
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
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_rounded, size: 18, color: Colors.black54),
                  SizedBox(width: 4),
                  Text('Volver', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
          ),
          leadingWidth: 100,
          title: const Text('Collage IA', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.negroCarbon)),
        ),
        body: SafeArea(
          child: _isGenerating ? _buildLoading() : _buildResult(),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48, height: 48,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.negroCarbon),
          ),
          const SizedBox(height: 24),
          const Text('Generando collage con IA', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.negroCarbon)),
          const SizedBox(height: 12),
          const Text('4 variaciones de peinado en una imagen', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black45)),
        ],
      ),
    );
  }

  Widget _buildResult() {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: Colors.black.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            const Text('Error al generar el collage', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _generateCollage,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.negroCarbon,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text('Reintentar', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    }

    if (_quadrants.length != 4) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image_outlined, size: 48, color: Colors.black.withValues(alpha: 0.15)),
            const SizedBox(height: 16),
            const Text('Error al procesar el collage', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final path = _quadrants[index];
                final hasFile = File(path).existsSync();
                return GestureDetector(
                  onTap: () {
                    if (_collagePath != null) {
                      Navigator.pushNamed(context, '/hairstyle_display', arguments: {
                        'style': HairstyleModel(
                          id: 'collage_$index',
                          name: 'Look ${index + 1}',
                          description: 'Variación de peinado ${index + 1}',
                          styleType: '',
                          maintenanceLevel: 'Moderado',
                          accentColor: AppColors.negroCarbon,
                          stylistSteps: [],
                          products: [],
                          imagePath: '',
                        ),
                        'photoPath': path,
                        'originalPhotoPath': _photoPath,
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: hasFile
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(File(path), fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder()),
                                    Positioned(
                                      top: 6, left: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.5),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text('IA', style: TextStyle(fontFamily: 'Poppins', fontSize: 7, fontWeight: FontWeight.w600, color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                )
                              : _placeholder(),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Look ${index + 1}',
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.negroCarbon),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.negroCarbon,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text('Volver al análisis', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.black.withValues(alpha: 0.05),
      child: Center(
        child: Icon(Icons.broken_image_outlined, size: 28, color: Colors.black.withValues(alpha: 0.15)),
      ),
    );
  }
}
