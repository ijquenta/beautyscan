import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../../data/repositories/colorimetry_repository.dart';
import '../components/atoms/beauty_background.dart';

class AnalysisResultsScreen extends StatefulWidget {
  const AnalysisResultsScreen({super.key});

  @override
  State<AnalysisResultsScreen> createState() => _AnalysisResultsScreenState();
}

class _AnalysisResultsScreenState extends State<AnalysisResultsScreen> {
  final ColorimetryRepository _repo = ColorimetryRepository();
  ColorimetryResultModel? _result;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_result == null) {
      final id = ModalRoute.of(context)!.settings.arguments as int?;
      if (id != null) {
        _loadData(id);
      } else {
        // Fallback error
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadData(int id) async {
    final data = await _repo.getResultById(id);
    setState(() {
      _result = data;
      _isLoading = false;
    });
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const BeautyBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text('CARGANDO...', style: TextStyle(fontFamily: 'Inter', letterSpacing: 2.0)),
          ),
        ),
      );
    }

    if (_result == null) {
      return const Scaffold(body: Center(child: Text('Error cargando resultado.')));
    }

    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header Editorial
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
                        child: const Text(
                          'VOLVER',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/gallery'),
                        child: const Text(
                          'GALERÍA',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 2.0,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 60, 32, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ANÁLISIS DE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                          color: Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _result!.clientName,
                        style: const TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.0,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _result!.season.replaceAll(' ', '\n'), // Separar "Primavera Cálida" en 2 líneas
                        style: const TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          height: 1.0,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Radial Palette Display
                      Center(
                        child: _RadialPaletteDisplay(
                          imagePath: _result!.photoPath,
                          recommended: _result!.recommendedColors.map(_hexToColor).toList(),
                          toAvoid: _result!.colorsToAvoid.map(_hexToColor).toList(),
                        ),
                      ),

                      const SizedBox(height: 48),
                      Container(
                        width: 40,
                        height: 1,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        _result!.makeupTips ?? 'Tonos exclusivos recomendados para optimizar tu colorimetría personal y destacar tu identidad natural.',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Metrics List text only
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      _EditorialMetric(label: 'Tono General', value: _result!.skinTone),
                      _EditorialMetric(label: 'Subtono', value: _result!.undertone),
                      const _EditorialMetric(label: 'Intensidad', value: 'Dinámica IA'),
                    ],
                  ),
                ),
              ),

              // Palette List Layout
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 60, 32, 20),
                  child: const Text(
                    'LA PALETA',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3.0,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 80),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildListDelegate(
                    _result!.recommendedColors.map((hex) => _EditorialColor(color: _hexToColor(hex))).toList(),
                  ),
                ),
              ),

              // Palette a Evitar
              if (_result!.colorsToAvoid.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 20),
                    child: const Text(
                      'COLORES A EVITAR',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 80),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildListDelegate(
                      _result!.colorsToAvoid.map((hex) => _EditorialColor(color: _hexToColor(hex), avoid: true)).toList(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EditorialMetric extends StatelessWidget {
  final String label;
  final String value;

  const _EditorialMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Inter',
              color: Colors.black38,
              fontSize: 11,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorialColor extends StatelessWidget {
  final Color color;
  final bool avoid;
  const _EditorialColor({required this.color, this.avoid = false});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: color, // Pure, flat color without border or drop shadows
          border: avoid ? Border.all(color: Colors.black26, width: 0.5) : null,
        ),
      ), 
    );
  }
}

class _RadialPaletteDisplay extends StatelessWidget {
  final String imagePath;
  final List<Color> recommended;
  final List<Color> toAvoid;

  const _RadialPaletteDisplay({
    required this.imagePath,
    required this.recommended,
    required this.toAvoid,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 300;
    const double imageSize = 160;
    const double radius = size / 2 - 15;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center Image
          ClipOval(
            child: imagePath.isNotEmpty && File(imagePath).existsSync()
              ? Image.file(
                  File(imagePath),
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: imageSize,
                  height: imageSize,
                  color: Colors.black12,
                ),
          ),
          
          // Recommended Colors (Left Hemisphere)
          if (recommended.isNotEmpty)
            ...List.generate(recommended.length, (index) {
              final double step = recommended.length > 1 ? pi / (recommended.length - 1) : 0;
              final double angle = pi / 2 + step * index; 
              return Positioned(
                left: size / 2 - 15 + radius * cos(angle),
                top: size / 2 - 15 + radius * sin(angle),
                child: _ColorPoint(color: recommended[index], size: 30),
              );
            }),
          
          // Avoid Colors (Right Hemisphere)
          if (toAvoid.isNotEmpty)
            ...List.generate(toAvoid.length, (index) {
              final double step = toAvoid.length > 1 ? pi / (toAvoid.length - 1) : 0;
              final double angle = pi / 2 - step * index; 
              return Positioned(
                left: size / 2 - 12 + radius * cos(angle),
                top: size / 2 - 12 + radius * sin(angle),
                child: _ColorPoint(color: toAvoid[index], size: 24, isAvoid: true),
              );
            }),
        ],
      ),
    );
  }
}

class _ColorPoint extends StatelessWidget {
  final Color color;
  final double size;
  final bool isAvoid;

  const _ColorPoint({required this.color, required this.size, this.isAvoid = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isAvoid ? Border.all(color: Colors.black26, width: 1.0) : null,
      ),
    );
  }
}
