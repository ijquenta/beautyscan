import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../domain/models/colorimetry_result_model.dart';
import '../../../domain/models/hair_colorimetry_result.dart';

class FormulaSheet extends StatefulWidget {
  final ColorimetryResultModel? colorimetry;
  final HairColorimetryResult? hairColorimetry;

  const FormulaSheet({super.key, this.colorimetry, this.hairColorimetry});

  @override
  State<FormulaSheet> createState() => _FormulaSheetState();
}

class _FormulaSheetState extends State<FormulaSheet> {
  String _selectedType = 'Global';
  String _selectedOxidant = '20';
  String _selectedLevel = '7';
  String _selectedTone = '0';
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

  @override
  void initState() {
    super.initState();
    if (widget.hairColorimetry != null) {
      _applyHairColorimetrySuggestion(widget.hairColorimetry!);
    } else if (widget.colorimetry != null) {
      _applyColorimetryFallback(widget.colorimetry!);
    }
  }

  /// Usa los datos reales del análisis capilar por IA para preseleccionar la fórmula.
  void _applyHairColorimetrySuggestion(HairColorimetryResult h) {
    _selectedLevel = h.recommendedFormulaLevel;
    _selectedTone = h.recommendedFormulaTone;
    _selectedOxidant = h.recommendedOxidant;
  }

  /// Fallback por temporada cuando no hay HairColorimetryResult disponible.
  void _applyColorimetryFallback(ColorimetryResultModel c) {
    final season = c.season.toLowerCase();

    if (season.contains('invierno')) {
      _selectedLevel = '2';
      _selectedTone = '1';
      _selectedOxidant = '20';
    } else if (season.contains('verano')) {
      _selectedLevel = '7';
      _selectedTone = '0';
      _selectedOxidant = '20';
    } else if (season.contains('oto')) {
      _selectedLevel = '5';
      _selectedTone = '4';
      _selectedOxidant = '30';
    } else if (season.contains('primavera')) {
      _selectedLevel = '8';
      _selectedTone = '3';
      _selectedOxidant = '30';
    }
  }

  String get _formula => '$_selectedLevel.$_selectedTone';
  String get _toneName => _toneNames[_selectedTone] ?? 'Natural';

  bool get _hasHairData => widget.hairColorimetry != null || widget.colorimetry != null;

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
        color: AppColors.beigeFondo,
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
                  if (_hasHairData)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.negroCarbon.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.negroCarbon.withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.negroCarbon.withValues(alpha: 0.5)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.hairColorimetry != null
                                    ? 'Recomendación IA personalizada: nivel $_selectedLevel tono $_selectedTone ($_toneName) · ${widget.hairColorimetry!.season}'
                                    : 'Según tu temporada ${widget.colorimetry!.season}, recomendamos nivel $_selectedLevel tono $_selectedTone ($_toneName)',
                                style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black54, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
