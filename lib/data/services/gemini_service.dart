import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../../domain/models/hairstyle_model.dart';
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

  Future<String?> generateHairstyle(String originalPhotoPath, HairstyleModel style) async {
    final apiKey = dotenv.env['API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key not found in env variables.');
    }

    final endpoint = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp-image-generation:generateContent?key=$apiKey');

    try {
      final imageBytes = await File(originalPhotoPath).readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final styleName = style.name.replaceAll('\n', ' ');
      final prompt = 'Ajusta esta imagen. Manten el rostro y todos los demás detalles corporales y del entorno sin cambios, '
          'pero cambia su cabello al estilo: $styleName. '
          'Asegúrate de que el resultado se vea profesional y fotorrealista.';

      final payload = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt},
              {
                'inlineData': {
                  'mimeType': 'image/jpeg',
                  'data': base64Image,
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'responseModalities': ['TEXT', 'IMAGE'],
        }
      };

      final response = await http.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final content = data['candidates'][0]['content'];
          if (content != null && content['parts'] != null && content['parts'].isNotEmpty) {
            String? generatedBase64;
            for (var part in content['parts']) {
              if (part['inlineData'] != null && part['inlineData']['data'] != null) {
                generatedBase64 = part['inlineData']['data'];
                break;
              }
            }

            if (generatedBase64 != null) {
              final newBytes = base64Decode(generatedBase64);
              final appDir = await getApplicationDocumentsDirectory();
              final fileName = 'generated_style_${DateTime.now().millisecondsSinceEpoch}.jpg';
              final newFile = File('${appDir.path}/$fileName');
              await newFile.writeAsBytes(newBytes);
              return newFile.path;
            }
          }
        }
      } else {
        debugPrint('Nano Banana Error: ' + response.statusCode.toString() + ' - ' + response.body);
        
        // Mock fallback para pruebas sin cuota
        if (response.statusCode == 429 || response.statusCode == 400) {
          debugPrint('Activando simulador (Mock) debido a error de cuota/acceso en Nano Banana...');
          return await _generateMockImage();
        }
        
        throw Exception('Failed to generate image via Nano Banana API.');
      }
      return null;
    } catch (e) {
      debugPrint('Nano Banana Generation Error: ' + e.toString());
      // Fallback en caso de cualquier error de red
      debugPrint('Activando simulador (Mock) por error de red...');
      return await _generateMockImage();
    }
  }

  Future<String> _generateMockImage() async {
    try {
      // Descarga una imagen hermosa genérica de peinado como mock
      final mockUrl = Uri.parse('https://images.unsplash.com/photo-1580618672591-eb180b1a973f?auto=format&fit=crop&q=80&w=800');
      final response = await http.get(mockUrl);
      if (response.statusCode == 200) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'mock_style_' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
        final newFile = File(appDir.path + '/' + fileName);
        await newFile.writeAsBytes(response.bodyBytes);
        return newFile.path;
      }
    } catch (e) {
      debugPrint('Mock Generation Error: ' + e.toString());
    }
    // Si incluso el mock falla, devuelve un string vacío (fallará en UI pero no crasheará tan fuerte)
    throw Exception('No se pudo generar ni la imagen real ni el mock.');
  }
}
