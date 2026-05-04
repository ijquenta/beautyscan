/// Resultado del análisis de colorimetría capilar.
/// Derivado del skinTone + undertone del análisis facial existente (Opción A).
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

  const HairColorimetryResult({
    required this.skinTone,
    required this.undertone,
    required this.season,
    required this.suggestedHairTones,
    required this.hairTonesToAvoid,
    required this.suggestedHairLabels,
    required this.hairCareAdvice,
    required this.stylistNote,
  });
}
