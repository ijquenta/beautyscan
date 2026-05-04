import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../../domain/models/hair_colorimetry_result.dart';
import '../../data/repositories/colorimetry_repository.dart';
import '../../data/services/hair_colorimetry_service.dart';

class ColorimetryDetailScreen extends StatefulWidget {
  const ColorimetryDetailScreen({super.key});

  @override
  State<ColorimetryDetailScreen> createState() =>
      _ColorimetryDetailScreenState();
}

class _ColorimetryDetailScreenState extends State<ColorimetryDetailScreen> {
  final ColorimetryRepository _repo = ColorimetryRepository();
  final HairColorimetryService _hairService = HairColorimetryService();

  ColorimetryResultModel? _result;
  HairColorimetryResult? _hairResult;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_result == null) {
      final id = ModalRoute.of(context)?.settings.arguments as int?;
      if (id != null) {
        _loadData(id);
      } else {
        // Sin ID: usar datos de demo
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

    // Datos reales si existen, o fallback de demostración
    final season = _result?.season ?? 'Primavera Cálida';
    final undertone = _result?.undertone ?? 'Cálido dorado';
    final skinTone = _result?.skinTone ?? 'Clara media';
    final recColors = _result?.recommendedColors ??
        ['E8936A', 'D4845A', 'BF6A3A', 'E8C060', 'D4A840'];
    final avoidColors = _result?.colorsToAvoid ??
        ['6080B0', '4060A0', '203870', '607890', '405870'];
    final makeupTips = _result?.makeupTips ??
        'Colores brillantes, cálidos y saturados que reflejan tu vitalidad natural.';
    final clientName = _result?.clientName;

    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.only(left: 32, top: 20),
              child: Text(
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
          ),
          leadingWidth: 100,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Encabezado Editorial ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clientName != null
                            ? 'ANÁLISIS · ${clientName.toUpperCase()}'
                            : 'TEMPORADA',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                          color: Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        season.replaceAll(' ', '\n'),
                        style: const TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 52,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: -1.0,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        makeupTips,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.black54,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Características ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                          child: _buildCharacteristic('SUBTONO', undertone)),
                      const SizedBox(width: 24),
                      Expanded(
                          child: _buildCharacteristic('TONO DE PIEL', skinTone)),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCharacteristic(
                            'SATURACIÓN',
                            undertone.toLowerCase().contains('cálido')
                                ? 'Alta – Viva'
                                : 'Media – Suave'),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildCharacteristic(
                            'CONTRASTE',
                            undertone.toLowerCase().contains('frío')
                                ? 'Claro – Medio'
                                : 'Medio – Bajo'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // ─── Paleta Favorecedora ──────────────────────────────────
                _buildSectionTitle('FAVORECEDORES'),
                const SizedBox(height: 24),
                _buildPaletteRow(
                  recColors.take(5).map(_hexToColor).toList(),
                  'TONOS RECOMENDADOS',
                ),

                const SizedBox(height: 48),

                _buildSectionTitle('A EVITAR'),
                const SizedBox(height: 24),
                _buildPaletteRow(
                  avoidColors.take(5).map(_hexToColor).toList(),
                  'TONOS A EVITAR',
                  isAvoid: true,
                ),

                // ════════════════════════════════════════════════════════
                // ─── SECCIÓN: COLORIMETRÍA CAPILAR ─────────────────────
                // ════════════════════════════════════════════════════════
                if (_hairResult != null) ...[
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 1, color: Colors.black12),
                        const SizedBox(height: 24),
                        const Text(
                          'COLORIMETRÍA CAPILAR',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3.5,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tonos de tinte recomendados según tu perfil cromático.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Colors.black45,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tonos capilares favorables
                  _buildSectionTitle('TINTES IDEALES'),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: _hairResult!.suggestedHairTones
                              .take(6)
                              .map((h) => Expanded(
                                    child: Container(
                                        height: 48,
                                        color: _hexToColor(h)),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 6,
                          children: _hairResult!.suggestedHairLabels
                              .take(6)
                              .map((l) => Text(
                                    l,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 9,
                                      letterSpacing: 1.5,
                                      color: Colors.black54,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Nota del colorista
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.black12)),
                      child: Text(
                        _hairResult!.stylistNote,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.black54,
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Tips de cuidado capilar
                  _buildSectionTitle('TIPS CAPILARES'),
                  const SizedBox(height: 24),
                  ..._hairResult!.hairCareAdvice.map((tip) => _buildTipRow(tip)),
                ],

                const SizedBox(height: 48),

                // ─── Tips de moda (facial) ─────────────────────────────────
                _buildSectionTitle('TIPS DE MODA'),
                const SizedBox(height: 24),
                ...[
                  'Opta por telas con brillo suave como seda o satén en tonos que complementen tu temporada.',
                  'Los estampados en tonos acordes a tu paleta son tus aliados naturales.',
                  'El tono metal ideal para accesorios depende de tu subtono: dorado para cálidos, plateado para fríos.',
                ].map((tip) => _buildTipRow(tip)),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 3.0,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCharacteristic(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 9,
            letterSpacing: 2.0,
            color: Colors.black45,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPaletteRow(List<Color> colors, String label,
      {bool isAvoid = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: colors
                .map((c) => Expanded(child: Container(height: 40, color: c)))
                .toList(),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 9,
              letterSpacing: 2.0,
              color: isAvoid ? Colors.black87 : Colors.black54,
              fontWeight: isAvoid ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
