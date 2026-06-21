import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../domain/models/hairstyle_model.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../../domain/models/hairstyle_result_model.dart';
import '../../data/services/gemini_service.dart';
import '../../data/repositories/hairstyle_repository.dart';
import '../../core/session_manager.dart';
import '../components/atoms/beauty_background.dart';

class LookbookScreen extends StatefulWidget {
  const LookbookScreen({super.key});

  @override
  State<LookbookScreen> createState() => _LookbookScreenState();
}

class _LookbookScreenState extends State<LookbookScreen> {
  final GeminiService _geminiService = GeminiService();
  final HairstyleRepository _hairstyleRepo = HairstyleRepository();
  final List<_LookResult> _results = [];
  bool _isGenerating = true;
  String? _photoPath;
  ColorimetryResultModel? _colorimetry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_results.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _photoPath = args?['photoPath'] as String?;
      _colorimetry = args?['colorimetry'] as ColorimetryResultModel?;
      if (_photoPath != null) _generateAll();
    }
  }

  Future<void> _generateAll() async {
    final styles = HairstyleModel.catalog;
    final results = <_LookResult>[];

    for (final style in styles) {
      results.add(_LookResult(style: style, status: 'Generando...'));
    }
    setState(() => _results.addAll(results));

    final futures = <Future<void>>[];
    for (int i = 0; i < styles.length; i++) {
      final idx = i;
      futures.add(_generateOne(styles[idx], idx));
    }
    await Future.wait(futures);

    if (mounted) setState(() => _isGenerating = false);
  }

  Future<void> _generateOne(HairstyleModel style, int index) async {
    try {
      final path = await _geminiService.generateHairstyle(
        _photoPath!,
        style,
        colorimetry: _colorimetry,
      );
      if (mounted && path != null) {
        setState(() => _results[index] = _LookResult(style: style, path: path, status: 'ok'));
        final userId = await SessionManager.getLoggedInUserId();
        if (userId != null) {
          _hairstyleRepo.saveResult(HairstyleResultModel(
            userId: userId,
            colorimetryResultId: _colorimetry?.id,
            originalPhotoPath: _photoPath!,
            hairstyleName: style.name.replaceAll('\n', ' '),
            resultImageUrl: path,
            createdAt: DateTime.now().toIso8601String(),
            personName: _colorimetry?.clientName ?? '',
          ));
        }
      } else if (mounted) {
        setState(() => _results[index] = _LookResult(style: style, status: 'Error'));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _results[index] = _LookResult(style: style, status: 'Error'));
      }
    }
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
          title: const Text('Lookbook IA', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.negroCarbon)),
        ),
        body: SafeArea(
          child: _isGenerating ? _buildLoading() : _buildGrid(),
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
          const Text('Generando looks con IA', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.negroCarbon)),
          const SizedBox(height: 20),
          ...HairstyleModel.catalog.asMap().entries.map((entry) {
            final idx = entry.key;
            final style = entry.value;
            final done = idx < _results.length && _results[idx].path != null;
            final error = idx < _results.length && _results[idx].status == 'Error';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? Colors.green : (error ? Colors.red : Colors.black12),
                    ),
                    child: Center(
                      child: done
                          ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                          : error
                              ? const Icon(Icons.close_rounded, size: 12, color: Colors.white)
                              : const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.black45)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    style.name.replaceAll('\n', ' '),
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: done ? Colors.black87 : Colors.black45),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final result = _results[index];
          final hasPath = result.path != null && File(result.path!).existsSync();
          return GestureDetector(
            onTap: () {
              if (hasPath) {
                Navigator.pushNamed(context, '/hairstyle_display', arguments: {
                  'style': result.style,
                  'photoPath': result.path,
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
                    child: hasPath
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(File(result.path!), fit: BoxFit.cover, errorBuilder: (_, __, ___) => _imagePlaceholder()),
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
                        : _imagePlaceholder(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      result.style.name.replaceAll('\n', ' '),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.negroCarbon),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.black.withValues(alpha: 0.05),
      child: Center(
        child: Icon(Icons.broken_image_outlined, size: 28, color: Colors.black.withValues(alpha: 0.15)),
      ),
    );
  }
}

class _LookResult {
  final HairstyleModel style;
  final String? path;
  final String status;
  _LookResult({required this.style, this.path, required this.status});
}
