import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../repositories/user_repository.dart';

class GeminiService {
  final _userRepo = UserRepository();

  Future<ColorimetryResultModel> analyzeColorimetry(Uint8List imageBytes, String photoPath, String clientName) async {
    final prompt = '''
Eres un Asesor de Imagen Cromatico de Alto Nivel de una Revista de Moda (Vogue, Harper's Bazaar).
Analiza esta foto del rostro de la persona para determinar su Estación Cromática con precisión.

DEBES RESPONDER ÚNICAMENTE CON UN JSON VÁLIDO. NI UNA PALABRA MÁS.
Estructura obligatoria del JSON:
{
  "skin_tone": "Ej. Medio-Cálido",
  "undertone": "Ej. Dorado",
  "season": "Ej. Primavera Cálida (O Estación que corresponda)",
  "recommended_colors": ["E8936A", "D4845A", "C2547A", "E8C060", "8BAE50", "4A9E8C"], 
  "colors_to_avoid": ["6080B0", "4060A0", "203870", "607890", "405870"],
  "makeup_tips": "Breve frase editorial recomendando maquillaje según su subtono."
}

INSTRUCCIONES DE COLORES:
- Devuelve EXACTAMENTE 6 colores en recommended_colors y EXACTAMENTE 5 en colors_to_avoid. 
- Deben ser códigos HEX limpios SIN el símbolo #.
- Manten un contraste editorial que represente bien su estación.
''';

    final gemini = Gemini.instance;

    try {
      final value = await gemini.textAndImage(
        text: prompt,
        images: [imageBytes],
      );

      String responseText = value?.output ?? '{}';

      // Limpiar si el modelo devuelve bloqus markdown de JSON
      responseText = responseText.replaceAll('```json', '').replaceAll('```', '').trim();

      final Map<String, dynamic> data = jsonDecode(responseText);

      // Obtener userId actual
      final user = await _userRepo.getCurrentUser();
      final userId = user?.id ?? 0; // fallback

      return ColorimetryResultModel(
        userId: userId,
        clientName: clientName,
        photoPath: photoPath,
        skinTone: data['skin_tone'] ?? 'Media',
        undertone: data['undertone'] ?? 'Neutra',
        season: data['season'] ?? 'Desconocida',
        recommendedColors: List<String>.from(data['recommended_colors'] ?? []),
        colorsToAvoid: List<String>.from(data['colors_to_avoid'] ?? []),
        makeupTips: data['makeup_tips'],
        createdAt: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      debugPrint('Gemini TextAndImage Error: $e');
      rethrow;
    }
  }
}
