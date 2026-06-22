import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../../domain/models/hair_colorimetry_result.dart';
import '../../domain/models/hairstyle_model.dart';
import '../repositories/user_repository.dart';
import '../../core/session_manager.dart';

class GeminiService {
  final _userRepo = UserRepository();

  Future<ColorimetryResultModel> analyzeColorimetry(
    Uint8List imageBytes,
    String photoPath,
    String clientName,
  ) async {
    final apiKey = dotenv.env['API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key not found in env variables.');
    }

    final schema = Schema.object(
      properties: {
        'skin_tone': Schema.string(description: 'descripcion del tono de piel'),
        'undertone': Schema.string(description: 'subtono (calido, frio o neutro)'),
        'season': Schema.string(description: 'estacion cromatica (Primavera Calida, Verano Frio, Otono Calido, o Invierno Frio)'),
        'recommended_colors': Schema.array(
          items: Schema.string(),
          description: 'EXACTAMENTE 6 codigos HEX sin #',
        ),
        'colors_to_avoid': Schema.array(
          items: Schema.string(),
          description: 'EXACTAMENTE 5 codigos HEX sin #',
        ),
        'makeup_tips': Schema.string(description: 'recomendacion breve de maquillaje'),
      },
      requiredProperties: ['skin_tone', 'undertone', 'season', 'recommended_colors', 'colors_to_avoid', 'makeup_tips'],
    );

    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schema,
      ),
    );

    const promptText = 'Eres un Asesor de Imagen Cromatico de Alto Nivel de una Revista de Moda. Analiza esta foto del rostro de la persona para determinar su Estacion Cromatica.';

    try {
      final response = await model.generateContent([
        Content.multi([
          TextPart(promptText),
          DataPart('image/jpeg', imageBytes),
        ]),
      ]);

      final responseText = response.text ?? '{}';
      debugPrint('Gemini JSON response: $responseText');

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

  /// Analiza la colorimetría capilar usando los datos del análisis facial ya realizado.
  /// No necesita la foto otra vez porque usa el resultado estructurado de Gemini.
  Future<HairColorimetryResult> analyzeHairColorimetry(
    ColorimetryResultModel colorimetry,
  ) async {
    final apiKey = dotenv.env['API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key not found in env variables.');
    }

    final schema = Schema.object(
      properties: {
        'suggested_hair_tones': Schema.array(
          items: Schema.string(),
          description: 'EXACTAMENTE 6 codigos HEX sin # de tonos de tinte recomendados para el cabello',
        ),
        'hair_tones_to_avoid': Schema.array(
          items: Schema.string(),
          description: 'EXACTAMENTE 4 codigos HEX sin # de tonos de tinte a evitar en el cabello',
        ),
        'suggested_hair_labels': Schema.array(
          items: Schema.string(),
          description: 'EXACTAMENTE 6 etiquetas en espanol para los tonos (ej: Rubio miel, Castaño ceniza, Caoba profunda)',
        ),
        'hair_care_advice': Schema.array(
          items: Schema.string(),
          description: 'EXACTAMENTE 5 consejos de cuidado capilar personalizados',
        ),
        'stylist_note': Schema.string(
          description: 'Nota tecnica de colorista con nivel y tono internacional (ej: 6.3) y recomendaciones profesionales',
        ),
        'recommended_formula_level': Schema.string(
          description: 'Nivel de formula del 1 al 10',
        ),
        'recommended_formula_tone': Schema.string(
          description: 'Tono de formula (0=Natural, 1=Cenizo, 3=Dorado, 4=Cobre, 5=Caoba, 6=Rojo, 7=Violeta, 8=Azul)',
        ),
        'recommended_oxidant': Schema.string(
          description: 'Volumen de oxidante (10, 20, 30 o 40)',
        ),
      },
      requiredProperties: [
        'suggested_hair_tones', 'hair_tones_to_avoid', 'suggested_hair_labels',
        'hair_care_advice', 'stylist_note',
        'recommended_formula_level', 'recommended_formula_tone', 'recommended_oxidant',
      ],
    );

    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schema,
      ),
    );

    final prompt = '''Eres un colorista profesional con 20 años de experiencia.
Basándote en el análisis facial ya realizado de una cliente, genera recomendaciones de colorimetría capilar REALES y PERSONALIZADAS.

DATOS DE LA CLIENTE:
- Temporada cromática: ${colorimetry.season}
- Tono de piel: ${colorimetry.skinTone}
- Subtono: ${colorimetry.undertone}
- Colores que le favorecen: ${colorimetry.recommendedColors.join(', ')}
- Colores a evitar: ${colorimetry.colorsToAvoid.join(', ')}
- Tips de maquillaje: ${colorimetry.makeupTips ?? 'No disponible'}

IMPORTANTE: Los tonos de tinte deben armonizar con TODO su perfil cromático, no solo con la temporada. Una cliente de "Primavera Cálida" con piel muy clara no recibe los mismos tonos que una de "Primavera Cálida" con piel oscura. Personaliza según sus datos específicos.''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final responseText = response.text ?? '{}';
      debugPrint('Hair Gemini response: $responseText');

      final Map<String, dynamic> data = jsonDecode(responseText);

      return HairColorimetryResult(
        skinTone: colorimetry.skinTone,
        undertone: colorimetry.undertone,
        season: colorimetry.season,
        suggestedHairTones: List<String>.from(data['suggested_hair_tones'] ?? []),
        hairTonesToAvoid: List<String>.from(data['hair_tones_to_avoid'] ?? []),
        suggestedHairLabels: List<String>.from(data['suggested_hair_labels'] ?? []),
        hairCareAdvice: List<String>.from(data['hair_care_advice'] ?? []),
        stylistNote: data['stylist_note'] ?? '',
        recommendedFormulaLevel: data['recommended_formula_level'] ?? '7',
        recommendedFormulaTone: data['recommended_formula_tone'] ?? '0',
        recommendedOxidant: data['recommended_oxidant'] ?? '20',
      );
    } catch (e) {
      debugPrint('Hair Gemini Error: $e');
      rethrow;
    }
  }

  Future<String?> generateHairstyle(
    String originalPhotoPath,
    HairstyleModel style, {
    ColorimetryResultModel? colorimetry,
  }) async {
    if (!await SessionManager.isImageGenerationEnabled()) {
      debugPrint('Generación de imágenes desactivada por el usuario.');
      return null;
    }
    final apiKey = dotenv.env['API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key not found in env variables.');
    }

    try {
      final imageBytes = await File(originalPhotoPath).readAsBytes();
      final styleName = style.name.replaceAll('\n', ' ');
      final styleDesc = style.description.replaceAll('\n', ' ');
      
      String colorContext = '';
      if (colorimetry != null) {
        colorContext = '''
INFORMACIÓN DE COLORIMETRÍA DE LA CLIENTE:
- Temporada cromática: ${colorimetry.season}
- Tono de piel: ${colorimetry.skinTone}
- Subtono: ${colorimetry.undertone}
- Colores que le favorecen: ${colorimetry.recommendedColors.join(', ')}
- Colores a evitar: ${colorimetry.colorsToAvoid.join(', ')}

El tono de tinte que apliques debe armonizar con todo su perfil cromático. No uses colores que desentonen con su temporada. Si el estilo indica un color específico, adáptalo para que favorezca a esta cliente en particular.''';
      }

      final prompt = '''Ajusta esta imagen. Mantén el rostro y todos los detalles corporales y del entorno SIN CAMBIOS.
Cambia el cabello al estilo: $styleName.
$styleDesc
$colorContext
Asegúrate de que el resultado se vea profesional, fotorrealista y armonioso con su perfil cromático.''';

      // To use the specific image generation model via raw REST HTTP because Dart SDK lacks responseModalities
      // We implement the spirit of the DataPart request while preserving functionality.
      final endpoint = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent?key=$apiKey');

      final payload = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt},
              {
                'inlineData': {
                  'mimeType': 'image/jpeg',
                  'data': base64Encode(imageBytes),
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'responseModalities': ['IMAGE'],
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
        debugPrint('Nano Banana Error: ${response.statusCode} - ${response.body}');
        if (response.statusCode == 429 || response.statusCode == 400 || response.statusCode == 404) {
          debugPrint('Activando simulador (Mock) debido a error de cuota/acceso en Nano Banana...');
          return await _generateMockImage();
        }
        throw Exception('Failed to generate image via Nano Banana API.');
      }
      return null;
    } catch (e) {
      debugPrint('Nano Banana Generation Error: $e');
      debugPrint('Activando simulador (Mock) por error de red...');
      return await _generateMockImage();
    }
  }

  Future<String?> generateHairstyleInfographic(
    String originalPhotoPath, {
    ColorimetryResultModel? colorimetry,
  }) async {
    if (!await SessionManager.isImageGenerationEnabled()) {
      debugPrint('Generación de imágenes desactivada por el usuario.');
      return null;
    }
    final apiKey = dotenv.env['API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key not found in env variables.');
    }

    try {
      final imageBytes = await File(originalPhotoPath).readAsBytes();
      
      String colorContext = '';
      if (colorimetry != null) {
        colorContext = '''
INFORMACIÓN DE COLORIMETRÍA DE LA CLIENTE:
- Temporada cromática: ${colorimetry.season}
- Tono de piel: ${colorimetry.skinTone}
- Subtono: ${colorimetry.undertone}
- Colores que le favorecen: ${colorimetry.recommendedColors.join(', ')}
- Colores a evitar: ${colorimetry.colorsToAvoid.join(', ')}

Cada uno de los 4 peinados debe tener un color de cabello DISTINTO que le favorezca según su colorimetría (no uses el mismo tono en los 4 cuadros). Varía entre tonos recomendados para mostrar opciones diferentes.''';
      }

      final prompt = '''Modifica esta imagen para crear un collage de 4 paneles (cuadrícula 2x2).
En cada panel muestra EXACTAMENTE a la misma persona de la imagen original, pero con 4 CORTES Y COLORES DE CABELLO distintos que le favorezcan.
$colorContext
Mantén el rostro idéntico en las 4 versiones.
Agrega una etiqueta visual corta en cada panel con el nombre del estilo/color.
El resultado DEBE ser una única imagen fotorrealista mostrando las 4 variaciones juntas.''';

      final endpoint = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent?key=$apiKey');

      final payload = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt},
              {
                'inlineData': {
                  'mimeType': 'image/jpeg',
                  'data': base64Encode(imageBytes),
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'responseModalities': ['IMAGE'],
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
              final fileName = 'generated_infographic_${DateTime.now().millisecondsSinceEpoch}.jpg';
              final newFile = File('${appDir.path}/$fileName');
              await newFile.writeAsBytes(newBytes);
              return newFile.path;
            }
          }
        }
      } else {
        debugPrint('Nano Banana Infographic Error: ${response.statusCode} - ${response.body}');
        if (response.statusCode == 429 || response.statusCode == 400 || response.statusCode == 404) {
          return await _generateMockImage();
        }
        throw Exception('Failed to generate infographic via API.');
      }
      return null;
    } catch (e) {
      debugPrint('Infographic Generation Error: $e');
      return await _generateMockImage();
    }
  }

  Future<String> _generateMockImage() async {
    throw Exception('La generación de imágenes no está disponible ahora. Verifica tu conexión y la clave API.');
  }
}
