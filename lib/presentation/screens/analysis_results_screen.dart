import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../../domain/models/hair_colorimetry_result.dart';
import '../../data/repositories/colorimetry_repository.dart';
import '../../data/services/hair_colorimetry_service.dart';
import '../components/atoms/beauty_background.dart';

class AnalysisResultsScreen extends StatefulWidget {
  const AnalysisResultsScreen({super.key});

  @override
  State<AnalysisResultsScreen> createState() => _AnalysisResultsScreenState();
}

class _AnalysisResultsScreenState extends State<AnalysisResultsScreen> {
  final ColorimetryRepository _repo = ColorimetryRepository();
  final HairColorimetryService _hairService = HairColorimetryService();

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
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.negroCarbon,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 12),
              Text(
                'Informe guardado — ${_result?.clientName ?? ''}',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showFormulaSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _FormulaSheet(),
    );
  }

  void _showStaticInfographic() {
    Navigator.pushNamed(context, '/lookbook', arguments: {
      'photoPath': _result?.photoPath ?? '',
      'colorimetry': _result,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const BeautyBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text('Cargando...',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.black54)),
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
                            child: Row(
                              children: [
                                Icon(Icons.arrow_back_rounded, size: 18, color: Colors.black.withValues(alpha: 0.5)),
                                const SizedBox(width: 6),
                                const Text('Volver', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.negroCarbon.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('Resultado', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: Colors.black45)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _result!.clientName,
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 40, fontWeight: FontWeight.w700, color: AppColors.negroCarbon, height: 1.0, letterSpacing: -1.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        dividerColor: Colors.transparent,
                        indicatorColor: AppColors.negroCarbon,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: AppColors.negroCarbon,
                        unselectedLabelColor: Colors.black38,
                        labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w400),
                        tabs: const [
                          Tab(text: 'Capilar'),
                          Tab(text: 'Facial'),
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
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.06))),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _BottomNavItem(
                      icon: Icons.home_rounded,
                      label: 'Inicio',
                      isActive: false,
                      onTap: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
                    ),
                    _BottomNavItem(
                      icon: _isSaving ? Icons.hourglass_empty_rounded : Icons.save_outlined,
                      label: 'Guardar',
                      isActive: true,
                      onTap: _isSaving ? null : _saveProReport,
                    ),
                    _BottomNavItem(
                      icon: Icons.ios_share_rounded,
                      label: 'Compartir',
                      isActive: false,
                      onTap: _saveProReport,
                    ),
                  ],
                ),
              ),
            ),
          ),
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
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.6),
                boxShadow: [
                  BoxShadow(color: AppColors.negroCarbon.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: ClipOval(
                child: _result!.photoPath.isNotEmpty && File(_result!.photoPath).existsSync()
                    ? Image.file(File(_result!.photoPath), width: 150, height: 150, fit: BoxFit.cover)
                    : Container(width: 150, height: 150, color: Colors.black12),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 36, 32, 16),
            child: _SectionHeader(icon: Icons.palette_outlined, title: 'Tonos de tinte favorables'),
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
            child: _SectionHeader(icon: Icons.block_outlined, title: 'Tonos a evitar en cabello'),
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
            child: _SectionHeader(icon: Icons.lightbulb_outline_rounded, title: 'Consejo del colorista'),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 8),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote_rounded, size: 20, color: Colors.black.withValues(alpha: 0.15)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _hairResult!.stylistNote,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black54, height: 1.7, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 16),
            child: _SectionHeader(icon: Icons.spa_outlined, title: 'Cuidados capilares'),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
              ),
              child: Column(
                children: _hairResult!.hairCareAdvice.map((tip) => _TipRow(text: tip)).toList(),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 16),
            child: _SectionHeader(icon: Icons.science_outlined, title: 'Fórmula de tintes'),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 8),
            child: GestureDetector(
              onTap: _showFormulaSheet,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.negroCarbon.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.colorize_rounded, size: 22, color: Colors.black54),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Calcular fórmula', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                          SizedBox(height: 2),
                          Text('Tinte, oxidante, cantidad y más', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.black45)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, size: 22, color: Colors.black.withValues(alpha: 0.15)),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/hairstyle_processing', arguments: {
                  'photoPath': _result!.photoPath,
                  'colorimetry': _result,
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.negroCarbon,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_fix_high_rounded, size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Probar peinados', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
            child: GestureDetector(
              onTap: _showStaticInfographic,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.negroCarbon.withValues(alpha: 0.3), width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.visibility_outlined, size: 16, color: AppColors.negroCarbon),
                      SizedBox(width: 8),
                      Text('Ver looks sugeridos', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.negroCarbon)),
                    ],
                  ),
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
                Container(width: 40, height: 2, decoration: BoxDecoration(color: AppColors.negroCarbon.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 16, color: Colors.black.withValues(alpha: 0.2)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _result!.makeupTips ?? 'Tonos exclusivos recomendados para optimizar tu colorimetría personal y destacar tu identidad natural.',
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54, height: 1.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
              ),
              child: Column(
                children: [
                  _EditorialMetric(label: 'Tono general', value: _result!.skinTone),
                  const Divider(height: 1, color: Colors.black12),
                  _EditorialMetric(label: 'Subtono', value: _result!.undertone),
                  const Divider(height: 1, color: Colors.black12),
                  const _EditorialMetric(label: 'Intensidad', value: 'Dinámica IA'),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 44, 32, 20),
            child: _SectionHeader(icon: Icons.palette_outlined, title: 'La paleta'),
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
              child: _SectionHeader(icon: Icons.block_outlined, title: 'Colores a evitar'),
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
      color: AppColors.beigeFondo,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.negroCarbon.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: Colors.black45),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
      ],
    );
  }
}

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
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: hexColors.take(6).map((h) => Expanded(
                child: Container(height: 52, color: _hex(h)),
              )).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Wrap(
              spacing: 16,
              runSpacing: 6,
              children: labels.take(6).map((l) => Text(
                l,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.black54),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final String text;
  const _TipRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.25),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black54, height: 1.5),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontFamily: 'Poppins', color: Colors.black45, fontSize: 12),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontFamily: 'Poppins', color: AppColors.negroCarbon, fontSize: 17, fontWeight: FontWeight.w600),
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
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: avoid ? Border.all(color: Colors.black.withValues(alpha: 0.15), width: 1) : null,
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

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.4),
        boxShadow: [
          BoxShadow(color: AppColors.negroCarbon.withValues(alpha: 0.06), blurRadius: 30, offset: const Offset(0, 10)),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: ClipOval(
              child: imagePath.isNotEmpty && File(imagePath).existsSync()
                  ? Image.file(File(imagePath), width: imageSize, height: imageSize, fit: BoxFit.cover)
                  : Container(width: imageSize, height: imageSize, color: Colors.black12),
            ),
          ),
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
        border: isAvoid ? Border.all(color: Colors.black.withValues(alpha: 0.2), width: 1.5) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.negroCarbon.withValues(alpha: 0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.black87 : Colors.black38,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? Colors.black87 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Formula Sheet ─────────────────────────────────────────────────────────

class _FormulaSheet extends StatefulWidget {
  const _FormulaSheet();

  @override
  State<_FormulaSheet> createState() => _FormulaSheetState();
}

class _FormulaSheetState extends State<_FormulaSheet> {
  String _selectedType = 'Global';
  String _selectedOxidant = '20';
  String _selectedLevel = '7';
  String _selectedTone = '3';
  String _length = 'Media';
  String _thickness = 'Normal';

  final List<String> _types = ['Global', 'Mechas', 'Balayage', 'Highlights'];
  final List<String> _oxidants = ['10', '20', '30', '40'];
  final List<String> _levels = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  final List<String> _tones = ['0', '1', '3', '4', '5', '6', '7', '8'];
  final Map<String, String> _toneNames = {
    '0': 'Natural', '1': 'Cenizo', '3': 'Dorado',
    '4': 'Cobre', '5': 'Caoba', '6': 'Rojo',
    '7': 'Violeta', '8': 'Azul',
  };
  final List<String> _lengths = ['Corto', 'Media', 'Largo', 'Muy largo'];
  final List<String> _thicknesses = ['Fino', 'Normal', 'Grueso', 'Muy grueso'];

  String get _formula => '$_selectedLevel.$_selectedTone';
  String get _toneName => _toneNames[_selectedTone] ?? 'Natural';

  double get _baseQuantity {
    final lenFactor = {'Corto': 30, 'Media': 60, 'Largo': 90, 'Muy largo': 120}[_length] ?? 60;
    final thickFactor = {'Fino': 0.7, 'Normal': 1.0, 'Grueso': 1.3, 'Muy grueso': 1.6}[_thickness] ?? 1.0;
    final typeFactor = _selectedType == 'Global' ? 1.0 : 0.5;
    return lenFactor * thickFactor * typeFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF9F1EA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(32, 20, 32, 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Fórmula de tintes', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.negroCarbon)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close_rounded, size: 22, color: Colors.black.withValues(alpha: 0.4)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white),
                      boxShadow: [
                        BoxShadow(color: AppColors.negroCarbon.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text('Fórmula', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: Colors.black45)),
                        const SizedBox(height: 12),
                        Text(
                          _formula,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 56, fontWeight: FontWeight.w700, color: AppColors.negroCarbon, letterSpacing: -2, height: 1),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _toneName,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _pill(label: 'Oxidante $_selectedOxidant vol.'),
                            const SizedBox(width: 8),
                            _pill(label: '${_baseQuantity.toInt()}g'),
                            const SizedBox(width: 8),
                            _pill(label: _selectedType),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _label('Tipo de aplicación'),
                  const SizedBox(height: 10),
                  _chipGroup(_types, _selectedType, (v) => setState(() => _selectedType = v)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _label('Nivel (1-10)')),
                      const SizedBox(width: 16),
                      Expanded(child: _label('Tono')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _chipGroup(_levels, _selectedLevel, (v) => setState(() => _selectedLevel = v))),
                      const SizedBox(width: 16),
                      Expanded(child: _chipGroup(_tones, _selectedTone, (v) => setState(() => _selectedTone = v))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _label('Oxidante (volúmenes)'),
                  const SizedBox(height: 10),
                  _chipGroup(_oxidants, _selectedOxidant, (v) => setState(() => _selectedOxidant = v)),
                  const SizedBox(height: 6),
                  Text(
                    _oxidantDescription,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.black45, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _label('Largo')),
                      const SizedBox(width: 16),
                      Expanded(child: _label('Abundancia')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _chipGroup(_lengths, _length, (v) => setState(() => _length = v))),
                      const SizedBox(width: 16),
                      Expanded(child: _chipGroup(_thicknesses, _thickness, (v) => setState(() => _thickness = v))),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.negroCarbon,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Resumen de aplicación', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        const SizedBox(height: 12),
                        _summaryRow('Fórmula', '$_formula · $_toneName'),
                        _summaryRow('Oxidante', '$_selectedOxidant vol. (${_oxidantLabel})'),
                        _summaryRow('Cantidad', '${_baseQuantity.toInt()}g de mezcla'),
                        _summaryRow('Aplicación', _selectedType),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded, size: 14, color: Colors.white.withValues(alpha: 0.6)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _applicationNote,
                                  style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.white.withValues(alpha: 0.6), height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _oxidantLabel {
    switch (_selectedOxidant) {
      case '10': return 'Bajo lifting';
      case '20': return 'Lifting estándar';
      case '30': return 'Alto lifting';
      case '40': return 'Máximo lifting / decoloración';
      default: return '';
    }
  }

  String get _oxidantDescription {
    switch (_selectedOxidant) {
      case '10': return 'Ideal para tono sobre tono o cubrir canas con mínimo daño. Proceso más lento.';
      case '20': return 'Estándar para mayoría de tintes. Buen balance entre velocidad y cuidado.';
      case '30': return 'Para aclarar 2-3 niveles. Mayor velocidad de decoloración.';
      case '40': return 'Para decoloración rápida (rubias). Actúa en menos tiempo pero más agresivo.';
      default: return '';
    }
  }

  String get _applicationNote {
    if (_selectedType == 'Global') {
      return 'Aplicar en todo el cabello seco. Respetar 2cm de raíz si hay color anterior. Tiempo de acción: 30-35 min.';
    } else if (_selectedType == 'Mechas') {
      return 'Separar mechas finas con papel aluminio. La mitad del cabello se procesa. Tiempo: 20-30 min según resultado.';
    } else if (_selectedType == 'Balayage') {
      return 'Aplicación manual desde la mitad del cabello hacia puntas. Degradado natural. Tiempo: 30-40 min.';
    } else {
      return 'Highlights en la parte superior y delantera. Separar 2cm del cuero cabelludo. Tiempo: 25-35 min.';
    }
  }

  Widget _label(String text) {
    return Text(text, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54));
  }

  Widget _pill({required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.negroCarbon.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.black54)),
    );
  }

  Widget _chipGroup(List<String> options, String selected, Function(String) onSelected) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: options.map((opt) {
        final active = opt == selected;
        return GestureDetector(
          onTap: () => onSelected(opt),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: active ? AppColors.negroCarbon : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: active ? Colors.transparent : Colors.black.withValues(alpha: 0.06)),
            ),
            child: Text(
              opt,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? Colors.white : Colors.black54,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
          Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
        ],
      ),
    );
  }
}
