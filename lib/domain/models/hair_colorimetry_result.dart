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
}
