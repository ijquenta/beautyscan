import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['API_KEY'] ?? '';
  try {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final response = await model.generateContent([Content.text('Hi')]);
    print('1.5-flash works: ${response.text}');
  } catch (e) {
    print('1.5-flash error: $e');
  }
}
