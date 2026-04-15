import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class AnalysisResultsScreen extends StatelessWidget {
  const AnalysisResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        onTap: () => Navigator.pop(context),
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
                        onTap: () {},
                        child: const Text(
                          'GUARDAR',
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
                        'EL RESULTADO',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                          color: Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Primavera\nCálida.',
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.0,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: 40,
                        height: 1,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Tonos vibrantes y soleados que\nmaximizan tu luminosidad natural.\nUn contraste medio pero radiante.',
                        style: TextStyle(
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
                    children: const [
                      _EditorialMetric(label: 'Rostro', value: 'Ovalado'),
                      _EditorialMetric(label: 'Subtono', value: 'Cálido'),
                      _EditorialMetric(label: 'Contraste', value: 'Medio'),
                      _EditorialMetric(label: 'Intensidad', value: 'Suave'),
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
                  delegate: SliverChildListDelegate(const [
                    _EditorialColor(color: Color(0xFFE8936A)),
                    _EditorialColor(color: Color(0xFFD4845A)),
                    _EditorialColor(color: Color(0xFFC2547A)),
                    _EditorialColor(color: Color(0xFFE8C060)),
                    _EditorialColor(color: Color(0xFF8BAE50)),
                    _EditorialColor(color: Color(0xFF4A9E8C)),
                  ]),
                ),
              ),

              // Bottom Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 60),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/colorimetry_detail'),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: const Text(
                            'Detalle del Análisis',
                            style: TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/hairstyle_processing'),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.black12, width: 1),
                              bottom: BorderSide(color: Colors.black12, width: 1),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: const Text(
                            'Simular Peinado',
                            style: TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 20,
                              color: Colors.black54,
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
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'PlayfairDisplay',
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorialColor extends StatelessWidget {
  final Color color;
  const _EditorialColor({required this.color});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(color: color), // Pure, flat color without border or drop shadows
    );
  }
}
