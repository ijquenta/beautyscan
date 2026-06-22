import 'package:flutter/foundation.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../../domain/models/hair_colorimetry_result.dart';
import 'gemini_service.dart';

/// Genera recomendaciones de colorimetría capilar.
///
/// Primero intenta obtener datos reales de Gemini IA con el análisis facial completo.
/// Si falla, usa un fallback determinista por temporada cromática.
class HairColorimetryService {
  final GeminiService _geminiService;

  HairColorimetryService({GeminiService? geminiService})
      : _geminiService = geminiService ?? GeminiService();

  /// Genera recomendaciones capilares personalizadas vía IA.
  /// Recibe el [ColorimetryResultModel] completo para que Gemini personalice
  /// según tono de piel, subtono, colores recomendados, etc.
  Future<HairColorimetryResult> generateFromColorimetry(
    ColorimetryResultModel colorimetry,
  ) async {
    try {
      return await _geminiService.analyzeHairColorimetry(colorimetry);
    } catch (e) {
      debugPrint('HairColorimetryService: Gemini falló, usando fallback: $e');
      return _fallbackBySeason(colorimetry);
    }
  }

  /// Fallback determinista cuando Gemini no está disponible.
  HairColorimetryResult _fallbackBySeason(ColorimetryResultModel c) {
    final normalized = c.season.toLowerCase();

    if (normalized.contains('primavera')) {
      return HairColorimetryResult(
        skinTone: c.skinTone,
        undertone: c.undertone,
        season: c.season,
        suggestedHairTones: ['D4A832', 'C8922A', 'B87820', 'E8C060', 'A06818', 'D4845A'],
        hairTonesToAvoid: ['A0A0B8', '808098', 'C0C0D0', '6870A0'],
        suggestedHairLabels: ['Rubio miel', 'Castaño dorado', 'Castaño cálido', 'Rubio champán', 'Cobrizo', 'Caoba cálida'],
        hairCareAdvice: [
          'Opta por tonos rubios miel, dorados o cobrizos que reflejen la luz cálida de tu piel.',
          'Evita los tonos ceniza o platino: enfría tu piel y apaga tu brillo natural.',
          'Los reflejos en tonos trigo o caramelo enmarcan el rostro de forma luminosa.',
          'Usa mascarillas nutritivas en tonos cálidos para mantener el pigmento vibrante.',
          'El brillo de gloss caramelado resalta perfectamente tu subtono dorado.',
        ],
        stylistNote: 'Temporada Primavera Cálida: priorizar pigmentos con base amarilla o naranja (tonos 6.3, 7.3, 8.3). Evitar sufijos .1 (ceniza) y .2 (beige frío).',
        recommendedFormulaLevel: '8',
        recommendedFormulaTone: '3',
        recommendedOxidant: '30',
      );
    }

    if (normalized.contains('verano')) {
      return HairColorimetryResult(
        skinTone: c.skinTone,
        undertone: c.undertone,
        season: c.season,
        suggestedHairTones: ['B0A0C8', '9890B8', '806888', 'C0B0D8', '706080', 'A89098'],
        hairTonesToAvoid: ['B87820', 'C8922A', 'D4A832', 'A06818'],
        suggestedHairLabels: ['Castaño ceniza', 'Rubio perla', 'Marrón malva', 'Rubio humo', 'Borgoña frío', 'Chocolate frío'],
        hairCareAdvice: [
          'Los tonos ceniza, malva y chocolate frío armonizan perfectamente con tu piel.',
          'Tintes con base violeta o azul realzan tu subtono frío de forma sofisticada.',
          'Reflejos platino suave o perla aportan luminosidad sin contrastar.',
          'Usa tratamientos morados para neutralizar el amarillo y mantener el reflejo frío.',
          'Evita cualquier tono cobrizo o dorado: crean contraste y fatigan el rostro.',
        ],
        stylistNote: 'Temporada Verano Frío: priorizar pigmentos con base violeta-azul (tonos 6.1, 7.1, 5.2). Tónicos violeta cada 4 semanas.',
        recommendedFormulaLevel: '7',
        recommendedFormulaTone: '0',
        recommendedOxidant: '20',
      );
    }

    if (normalized.contains('oto')) {
      return HairColorimetryResult(
        skinTone: c.skinTone,
        undertone: c.undertone,
        season: c.season,
        suggestedHairTones: ['8B4513', 'A0522D', 'C04020', 'D2691E', '6B3010', 'B05020'],
        hairTonesToAvoid: ['C0C0D0', 'A0A0B8', 'F0E8D0', 'D0C8B0'],
        suggestedHairLabels: ['Castaño oscuro', 'Caoba profunda', 'Rojizo terracota', 'Cobrizo intenso', 'Negro cálido', 'Canela especiada'],
        hairCareAdvice: [
          'Los rojos terracota, cobrizos intensos y caobas profundas definen tu paleta capilar ideal.',
          'El negro cálido con reflejos caoba enmarca tu piel de oliva o dorada de forma magistral.',
          'Tintes en gama 4 y 5 con sufijo .4 (cobrizo) o .46 (caoba-cobrizo) son tu mejor opción.',
          'Aplica mascarilla de color rojiza cada 2 semanas para mantener la intensidad capilar.',
          'Evita los rubios beige o platinos: dejan la piel sin vida y apagan tu intensidad natural.',
        ],
        stylistNote: 'Temporada Otoño Cálido: tonos 4.4, 5.4, 5.45, 4.46 (gama rojo-cobrizo). El rojo ladrillo es tu tono estrella.',
        recommendedFormulaLevel: '5',
        recommendedFormulaTone: '4',
        recommendedOxidant: '30',
      );
    }

    return HairColorimetryResult(
      skinTone: c.skinTone,
      undertone: c.undertone,
      season: c.season,
      suggestedHairTones: ['1A1A2E', '16213E', '2C2C54', '0F3460', '533483', '202040'],
      hairTonesToAvoid: ['D4A832', 'C8922A', 'B87820', 'D4845A'],
      suggestedHairLabels: ['Negro azabache', 'Castaño muy oscuro', 'Borgoña oscuro', 'Negro con brillo azul', 'Ciruela profunda', 'Café negro'],
      hairCareAdvice: [
        'El negro azabache o el castaño muy oscuro son tus absolutos aliados capilares.',
        'Los borgoñas y ciruelas fríos intensifican el contraste natural de tu piel.',
        'El brillo azul o violeta oscuro en el cabello negro añade dimensión sin artificialidad.',
        'Evita decolorar por encima de nivel 6: los tonos medios debilitan el impacto de tu temporada.',
        'Trata el cabello con mascarillas reconstructoras para mantener el brillo espejo.',
      ],
      stylistNote: 'Temporada Invierno Frío: máximo contraste. Tonos 1, 2, 3 con sufijos .1 o .2. El borgoña (3.6 o 4.65) es una alternativa premium.',
      recommendedFormulaLevel: '2',
      recommendedFormulaTone: '1',
      recommendedOxidant: '20',
    );
  }
}
