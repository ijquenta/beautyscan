import 'dart:convert';

/// Resultado del análisis de colorimetría capilar.
/// Generado por IA a partir del análisis facial o con fallback determinista.
class HairColorimetryResult {
  final String skinTone;
  final String undertone;
  final String season;

  /// Tonos de tinte capilar recomendados (hex sin #).
  final List<String> suggestedHairTones;

  /// Tonos de tinte a evitar (hex sin #).
  final List<String> hairTonesToAvoid;

  /// Etiquetas legibles para los tonos recomendados.
  final List<String> suggestedHairLabels;

  /// Consejos técnicos automáticos para el estilista.
  final List<String> hairCareAdvice;

  /// Nota técnica del colorista.
  final String stylistNote;

  /// Nivel de fórmula recomendado (1-10) para el FormulaSheet.
  final String recommendedFormulaLevel;

  /// Tono de fórmula recomendado (0=Cenizo, 3=Dorado, 4=Cobre, etc.).
  final String recommendedFormulaTone;

  /// Volumen de oxidante recomendado (10, 20, 30, 40).
  final String recommendedOxidant;

  const HairColorimetryResult({
    required this.skinTone,
    required this.undertone,
    required this.season,
    required this.suggestedHairTones,
    required this.hairTonesToAvoid,
    required this.suggestedHairLabels,
    required this.hairCareAdvice,
    required this.stylistNote,
    this.recommendedFormulaLevel = '7',
    this.recommendedFormulaTone = '0',
    this.recommendedOxidant = '20',
  });

  Map<String, dynamic> toJson() => {
        'skin_tone': skinTone,
        'undertone': undertone,
        'season': season,
        'suggested_hair_tones': suggestedHairTones,
        'hair_tones_to_avoid': hairTonesToAvoid,
        'suggested_hair_labels': suggestedHairLabels,
        'hair_care_advice': hairCareAdvice,
        'stylist_note': stylistNote,
        'recommended_formula_level': recommendedFormulaLevel,
        'recommended_formula_tone': recommendedFormulaTone,
        'recommended_oxidant': recommendedOxidant,
      };

  factory HairColorimetryResult.fromJson(Map<String, dynamic> json) =>
      HairColorimetryResult(
        skinTone: json['skin_tone'] as String? ?? '',
        undertone: json['undertone'] as String? ?? '',
        season: json['season'] as String? ?? '',
        suggestedHairTones:
            List<String>.from(json['suggested_hair_tones'] ?? []),
        hairTonesToAvoid:
            List<String>.from(json['hair_tones_to_avoid'] ?? []),
        suggestedHairLabels:
            List<String>.from(json['suggested_hair_labels'] ?? []),
        hairCareAdvice:
            List<String>.from(json['hair_care_advice'] ?? []),
        stylistNote: json['stylist_note'] as String? ?? '',
        recommendedFormulaLevel:
            json['recommended_formula_level'] as String? ?? '7',
        recommendedFormulaTone:
            json['recommended_formula_tone'] as String? ?? '0',
        recommendedOxidant:
            json['recommended_oxidant'] as String? ?? '20',
      );

  String toJsonString() => jsonEncode(toJson());

  factory HairColorimetryResult.fromJsonString(String jsonString) =>
      HairColorimetryResult.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>);
}
