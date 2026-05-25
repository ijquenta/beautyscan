import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../../domain/models/hair_colorimetry_result.dart';
import '../../data/repositories/colorimetry_repository.dart';
import '../../data/services/hair_colorimetry_service.dart';
import '../../data/services/gemini_service.dart';
import '../components/atoms/beauty_background.dart';

class AnalysisResultsScreen extends StatefulWidget {
  const AnalysisResultsScreen({super.key});

  @override
  State<AnalysisResultsScreen> createState() => _AnalysisResultsScreenState();
}

class _AnalysisResultsScreenState extends State<AnalysisResultsScreen> {
  final ColorimetryRepository _repo = ColorimetryRepository();
  final HairColorimetryService _hairService = HairColorimetryService();
  final GeminiService _geminiService = GeminiService();

  ColorimetryResultModel? _result;
  HairColorimetryResult? _hairResult;
  bool _isLoading = true;
  bool _isSaving = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_result == null) {
      final id = ModalRoute.of(context)!.settings.arguments as int?;
      if (id != null) {
        _loadData(id);
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadData(int id) async {
    final data = await _repo.getResultById(id);
    if (data != null) {
      final hair = _hairService.generateFromColorimetry(
        skinTone: data.skinTone,
        undertone: data.undertone,
        season: data.season,
      );
      setState(() {
        _result = data;
        _hairResult = hair;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  Future<void> _saveProReport() async {
    setState(() => _isSaving = true);
    // Simulación de guardado / export
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          content: Text(
            'INFORME PRO GUARDADO — ${_result?.clientName ?? ''}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  void _showStaticInfographic() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'LOOKS SUGERIDOS',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.asset('assets/images/imagen-looks.jpeg'),
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const BeautyBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text('CARGANDO...',
                style: TextStyle(fontFamily: 'Inter', letterSpacing: 2.0)),
          ),
        ),
      );
    }

    if (_result == null) {
      return const Scaffold(
          body: Center(child: Text('Error cargando resultado.')));
    }

    return BeautyBackground(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
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
                              style: TextStyle(fontFamily: 'Inter', fontSize: 10, letterSpacing: 2.0, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ANÁLISIS DE',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3.0, color: Colors.black38),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _result!.clientName,
                            style: const TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.0, letterSpacing: -1.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      const TabBar(
                        dividerColor: Colors.transparent,
                        indicatorColor: Colors.black87,
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.black38,
                        labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                        tabs: [
                          Tab(text: 'CAPILAR'),
                          Tab(text: 'FACIAL'),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  _buildCapilarTab(),
                  _buildFacialTab(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomSaveButton(),
        ),
      ),
    );
  }

  Widget _buildCapilarTab() {
    if (_hairResult == null) {
      return const Center(child: Text('No hay datos capilares.'));
    }
    return CustomScrollView(
      key: const PageStorageKey<String>('capilar'),
      slivers: [
        SliverToBoxAdapter(child: const SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: Center(
            child: ClipOval(
              child: _result!.photoPath.isNotEmpty && File(_result!.photoPath).existsSync()
                  ? Image.file(File(_result!.photoPath),
                      width: 160, height: 160, fit: BoxFit.cover)
                  : Container(
                      width: 160,
                      height: 160,
                      color: Colors.black12,
                    ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
            child: const Text('TONOS DE TINTE FAVORABLES', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3.0, color: Colors.black38)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: _HairPaletteRow(
              hexColors: _hairResult!.suggestedHairTones,
              labels: _hairResult!.suggestedHairLabels,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 16),
            child: const Text('TONOS A EVITAR EN CABELLO', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3.0, color: Colors.black38)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 1.0, crossAxisSpacing: 12, mainAxisSpacing: 12,
            ),
            delegate: SliverChildListDelegate(
              _hairResult!.hairTonesToAvoid.map((hex) => _EditorialColor(color: _hexToColor(hex), avoid: true)).toList(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 16),
            child: const Text('CONSEJO DEL COLORISTA', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3.0, color: Colors.black38)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
              child: Text(
                _hairResult!.stylistNote,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.black54, height: 1.6, fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
            child: const Text('CUIDADOS CAPILARES', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3.0, color: Colors.black38)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
            child: Column(
              children: _hairResult!.hairCareAdvice.map((tip) => _TipRow(text: tip)).toList(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/hairstyle_processing', arguments: {
                  'photoPath': _result!.photoPath,
                  'colorimetry': _result,
                });
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: Colors.black87, width: 1.5), color: Colors.transparent),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Center(
                  child: Text('PROBAR PEINADOS', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3.0, color: Colors.black87)),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
            child: GestureDetector(
              onTap: _showStaticInfographic,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87, width: 1.5),
                  color: Colors.transparent,
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Center(
                  child: Text('VER LOOKS SUGERIDOS', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3.0, color: Colors.black87)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFacialTab() {
    return CustomScrollView(
      key: const PageStorageKey<String>('facial'),
      slivers: [
        SliverToBoxAdapter(child: const SizedBox(height: 40)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _RadialPaletteDisplay(
                    imagePath: _result!.photoPath,
                    recommended: _result!.recommendedColors.map(_hexToColor).toList(),
                    toAvoid: _result!.colorsToAvoid.map(_hexToColor).toList(),
                  ),
                ),
                const SizedBox(height: 48),
                Container(width: 40, height: 1, color: Colors.black87),
                const SizedBox(height: 32),
                Text(
                  _result!.makeupTips ?? 'Tonos exclusivos recomendados para optimizar tu colorimetría personal y destacar tu identidad natural.',
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.black54, height: 1.6),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
            child: Column(
              children: [
                _EditorialMetric(label: 'Tono General', value: _result!.skinTone),
                _EditorialMetric(label: 'Subtono', value: _result!.undertone),
                const _EditorialMetric(label: 'Intensidad', value: 'Dinámica IA'),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 48, 32, 20),
            child: const Text('LA PALETA', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3.0, color: Colors.black38)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 1.0, crossAxisSpacing: 16, mainAxisSpacing: 16,
            ),
            delegate: SliverChildListDelegate(
              _result!.recommendedColors.map((hex) => _EditorialColor(color: _hexToColor(hex))).toList(),
            ),
          ),
        ),
        if (_result!.colorsToAvoid.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 20),
              child: const Text('COLORES A EVITAR', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3.0, color: Colors.black38)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 60),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 1.0, crossAxisSpacing: 16, mainAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate(
                _result!.colorsToAvoid.map((hex) => _EditorialColor(color: _hexToColor(hex), avoid: true)).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomSaveButton() {
    return GestureDetector(
      onTap: _isSaving ? null : _saveProReport,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 70, // Fixed height for bottomNavigationBar
        color: _isSaving ? Colors.black45 : Colors.black87,
        child: Center(
          child: _isSaving
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.white))
              : const Text('GUARDAR', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3.0, color: Colors.white)),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// ─── Section Divider ────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 60, 32, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 1, color: Colors.black12),
          const SizedBox(height: 20),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 3.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hair Palette Row ────────────────────────────────────────────────────────

class _HairPaletteRow extends StatelessWidget {
  final List<String> hexColors;
  final List<String> labels;

  const _HairPaletteRow({required this.hexColors, required this.labels});

  Color _hex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Franja de colores
        Row(
          children: hexColors.take(6).map((h) => Expanded(
            child: Container(height: 48, color: _hex(h)),
          )).toList(),
        ),
        const SizedBox(height: 16),
        // Nombres de los tonos
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: labels.take(6).map((l) => Text(
            l,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 9,
              letterSpacing: 1.5,
              color: Colors.black54,
            ),
          )).toList(),
        ),
      ],
    );
  }
}

// ─── Tip Row ────────────────────────────────────────────────────────────────

class _TipRow extends StatelessWidget {
  final String text;
  const _TipRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '—',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Editorial Metric ────────────────────────────────────────────────────────

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

// ─── Editorial Color Block ───────────────────────────────────────────────────

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
          color: color,
          border:
              avoid ? Border.all(color: Colors.black26, width: 0.5) : null,
        ),
      ),
    );
  }
}

// ─── Radial Palette Display ──────────────────────────────────────────────────

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
          ClipOval(
            child: imagePath.isNotEmpty && File(imagePath).existsSync()
                ? Image.file(File(imagePath),
                    width: imageSize, height: imageSize, fit: BoxFit.cover)
                : Container(
                    width: imageSize,
                    height: imageSize,
                    color: Colors.black12,
                  ),
          ),
          if (recommended.isNotEmpty)
            ...List.generate(recommended.length, (index) {
              final double step =
                  recommended.length > 1 ? pi / (recommended.length - 1) : 0;
              final double angle = pi / 2 + step * index;
              return Positioned(
                left: size / 2 - 15 + radius * cos(angle),
                top: size / 2 - 15 + radius * sin(angle),
                child: _ColorPoint(color: recommended[index], size: 30),
              );
            }),
          if (toAvoid.isNotEmpty)
            ...List.generate(toAvoid.length, (index) {
              final double step =
                  toAvoid.length > 1 ? pi / (toAvoid.length - 1) : 0;
              final double angle = pi / 2 - step * index;
              return Positioned(
                left: size / 2 - 12 + radius * cos(angle),
                top: size / 2 - 12 + radius * sin(angle),
                child:
                    _ColorPoint(color: toAvoid[index], size: 24, isAvoid: true),
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
  const _ColorPoint(
      {required this.color, required this.size, this.isAvoid = false});

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
