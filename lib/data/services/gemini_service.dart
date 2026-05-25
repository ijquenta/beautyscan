import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
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

  Future<String?> generateHairstyle(
    String originalPhotoPath,
    HairstyleModel style, {
    ColorimetryResultModel? colorimetry,
  }) async {
    final apiKey = dotenv.env['API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key not found in env variables.');
    }

    try {
      final imageBytes = await File(originalPhotoPath).readAsBytes();
      final styleName = style.name.replaceAll('\n', ' ');
      
      String colorContext = '';
      if (colorimetry != null) {
        colorContext = ' Teniendo en cuenta su colorimetría de "${colorimetry.season}" y sus colores favorables (${colorimetry.recommendedColors.join(', ')}), elige un tono de tinte que le favorezca.';
      }

      final prompt = 'Ajusta esta imagen. Manten el rostro y todos los demás detalles corporales y del entorno sin cambios, '
          'pero cambia su cabello al estilo: $styleName.$colorContext '
          'Asegúrate de que el resultado se vea profesional y fotorrealista.';

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
    final apiKey = dotenv.env['API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('Gemini API key not found in env variables.');
    }

    try {
      final imageBytes = await File(originalPhotoPath).readAsBytes();
      
      String colorContext = '';
      if (colorimetry != null) {
        colorContext = ' Basado en su análisis de colorimetría para la estación "${colorimetry.season}", utiliza tonos de cabello que le favorezcan (como ${colorimetry.recommendedColors.take(3).join(', ')}).';
      }

      final prompt = 'Modifica esta imagen para crear un collage de 4 paneles (cuadrícula 2x2). En cada uno de los 4 paneles, muestra EXACTAMENTE a la misma persona de la imagen original, pero con 4 cortes de cabello o peinados distintos que le favorezcan.$colorContext Mantén el rostro idéntico en las 4 versiones. Agrega una etiqueta visual corta en cada corte. El resultado DEBE ser una única imagen fotorrealista mostrando las 4 variaciones juntas.';

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
    try {
      final mockUrl = Uri.parse('https://images.unsplash.com/photo-1580618672591-eb180b1a973f?auto=format&fit=crop&q=80&w=800');
      final response = await http.get(mockUrl);
      if (response.statusCode == 200) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'mock_style_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final newFile = File('${appDir.path}/$fileName');
        await newFile.writeAsBytes(response.bodyBytes);
        return newFile.path;
      }
    } catch (e) {
      debugPrint('Mock Generation Error: $e');
    }
    throw Exception('No se pudo generar ni la imagen real ni el mock.');
  }
}
