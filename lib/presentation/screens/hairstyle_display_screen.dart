import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../../domain/models/hairstyle_model.dart';
import '../components/molecules/formula_sheet.dart';

class HairstyleDisplayScreen extends StatefulWidget {
  const HairstyleDisplayScreen({super.key});

  @override
  State<HairstyleDisplayScreen> createState() => _HairstyleDisplayScreenState();
}

class _HairstyleDisplayScreenState extends State<HairstyleDisplayScreen> {
  String? _originalPhotoPath;
  String? _photoPath;
  HairstyleModel? _style;
  ColorimetryResultModel? _colorimetry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _style = args['style'] as HairstyleModel?;
      _photoPath = args['photoPath'] as String?;
      _originalPhotoPath = args['originalPhotoPath'] as String?;
      _colorimetry = args['colorimetry'] as ColorimetryResultModel?;
    } else if (args is HairstyleModel) {
      _style = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final photoPath = _photoPath;
    final originalPath = _originalPhotoPath;
    final isBlonde = style?.id == 'rubio_ia';

    return Scaffold(
      backgroundColor: AppColors.beigeFondo,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_rounded, size: 18, color: Colors.black.withValues(alpha: 0.5)),
                          const SizedBox(width: 6),
                          const Text('Volver', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/hairstyle_detail', arguments: style),
                      child: Row(
                        children: [
                          const Text('Detalles', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black54)),
                          Icon(Icons.chevron_right_rounded, size: 18, color: Colors.black.withValues(alpha: 0.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Resultado', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: Colors.black45)),
                    const SizedBox(height: 8),
                    Text(
                      style != null ? style.name.replaceAll('\n', ' ') : 'Simulación',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.negroCarbon, letterSpacing: -0.8, height: 1.0),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: _buildImage(originalPath, esOriginal: true),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_outline_rounded, size: 12, color: Colors.black.withValues(alpha: 0.25)),
                            const SizedBox(width: 6),
                            Text('Original', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.black.withValues(alpha: 0.35))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
                    boxShadow: [
                      BoxShadow(color: AppColors.negroCarbon.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: _buildImage(photoPath, esOriginal: false),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome_rounded, size: 12, color: AppColors.negroCarbon.withValues(alpha: 0.35)),
                            const SizedBox(width: 6),
                            Text(isBlonde ? 'Generado por Rubios IA' : 'Generado por IA', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.black.withValues(alpha: 0.5))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 48),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.negroCarbon,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save_outlined, size: 16, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Guardar', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => FormulaSheet(
                              colorimetry: _colorimetry,
                              hairColorimetry: _colorimetry?.hairResult,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.negroCarbon.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.colorize_rounded, size: 16, color: AppColors.negroCarbon),
                                SizedBox(width: 8),
                                Text('Calcular fórmula', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.negroCarbon)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? path, {required bool esOriginal}) {
    if (path != null && File(path).existsSync()) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => _imageError(),
      );
    }
    return _imageError();
  }

  Widget _imageError() {
    return Container(
      color: Colors.black.withValues(alpha: 0.05),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image_outlined, size: 32, color: Colors.black.withValues(alpha: 0.15)),
            const SizedBox(height: 8),
            Text('Imagen no disponible', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.black.withValues(alpha: 0.2))),
          ],
        ),
      ),
    );
  }
}
