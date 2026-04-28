import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../repositories/user_repository.dart';

class GeminiService {
  final _userRepo = UserRepository();

  Future<ColorimetryResultModel> analyzeColorimetry(
    Uint8List imageBytes,
    String photoPath,
    String clientName,
  ) async {
    const promptText = '''
Eres un Asesor de Imagen Cromatico de Alto Nivel de una Revista de Moda.
Analiza esta foto del rostro de la persona para determinar su Estacion Cromatica.

RESPONDE UNICAMENTE CON UN JSON VALIDO. SIN TEXTO ADICIONAL. SIN MARKDOWN.
{
  "skin_tone": "descripcion del tono de piel",
  "undertone": "subtono (calido, frio o neutro)",
  "season": "estacion cromatica (Primavera Calida, Verano Frio, Otono Calido, o Invierno Frio)",
  "recommended_colors": ["E8936A", "D4845A", "C2547A", "E8C060", "8BAE50", "4A9E8C"],
  "colors_to_avoid": ["6080B0", "4060A0", "203870", "607890", "405870"],
  "makeup_tips": "recomendacion breve de maquillaje"
}

IMPORTANTE: recommended_colors debe tener EXACTAMENTE 6 codigos HEX sin # y colors_to_avoid EXACTAMENTE 5.
''';

    final gemini = Gemini.instance;

    try {
      // Use the prompt method with both text and image parts
      final value = await gemini.prompt(
        parts: [
          Part.text(promptText),
          Part.inline(InlineData(mimeType: 'image/jpeg', data: base64Encode(imageBytes))),
        ],
      );

      String responseText = value?.output ?? '{}';

      // Remove markdown wrappers if model adds them
      if (responseText.contains('```')) {
        final startIdx = responseText.indexOf('{');
        final endIdx = responseText.lastIndexOf('}');
        if (startIdx >= 0 && endIdx >= 0) {
          responseText = responseText.substring(startIdx, endIdx + 1);
        }
      }

      responseText = responseText.trim();
      debugPrint('Gemini response: $responseText');

      final Map<String, dynamic> data = jsonDecode(responseText);

      final user = await _userRepo.getCurrentUser();
      final userId = user?.id ?? 0;

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
      debugPrint('Gemini Error: $e');
      rethrow;
    }
  }
}
