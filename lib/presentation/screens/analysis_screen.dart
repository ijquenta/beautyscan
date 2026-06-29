import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/constants.dart';
import '../../data/services/gemini_service.dart';
import '../../data/services/hair_colorimetry_service.dart';
import '../../data/repositories/colorimetry_repository.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final GeminiService _geminiService = GeminiService();
  final HairColorimetryService _hairService = HairColorimetryService();
  String _statusText = 'Analizando colorimetría facial';
  double _progress = 0.0;

  final List<String> _steps = [
    'Analizando colorimetría facial',
    'Generando paleta de colores',
    'Analizando colorimetría capilar',
    'Preparando recomendaciones',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processImageWithGemini();
    });
  }

  void _updateProgress() {
    if (!mounted) return;
    setState(() {
      final stepProgress = (_progress * _steps.length).floor().clamp(0, _steps.length - 1);
      _statusText = _steps[stepProgress];
      _progress += 0.01;
      if (_progress > 0.95) _progress = 0.95;
    });
  }

  Future<void> _processImageWithGemini() async {
    final timer = Stream.periodic(const Duration(milliseconds: 200), (_) => _updateProgress());
    final sub = timer.listen(null);

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

      final colorimetryRepo = ColorimetryRepository();

      final resultModel = await _geminiService.analyzeColorimetry(fileBytes, persistentPath, clientName);

      final savedId = await colorimetryRepo.saveResult(resultModel);

      setState(() => _progress = 0.5);

      final hairResult = await _hairService.generateFromColorimetry(resultModel);

      await colorimetryRepo.updateHairResult(savedId, hairResult.toJsonString());

      sub.cancel();

      if (mounted) {
        setState(() => _progress = 1.0);
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/analysis_results',
            arguments: {'id': savedId, 'hairResult': hairResult},
          );
        }
      }
    } catch (e) {
      sub.cancel();
      debugPrint("Error al procesar con Gemini: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.negroCarbon,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beigeFondo,
      body: Column(
        children: [
          const Spacer(flex: 3),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.negroCarbon.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome_rounded, size: 24, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _statusText,
              key: ValueKey(_statusText),
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Poppins', color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Análisis con IA en progreso',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.black.withValues(alpha: 0.35), fontSize: 11),
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
                    color: Colors.black.withValues(alpha: 0.08),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _progress,
                      child: Container(color: AppColors.negroCarbon),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
