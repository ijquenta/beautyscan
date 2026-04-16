import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:beautyscan/core/theme.dart';
import 'package:beautyscan/presentation/screens/splash_screen.dart';
import 'package:beautyscan/presentation/screens/onboarding_screen.dart';
import 'package:beautyscan/presentation/screens/login_screen.dart';
import 'package:beautyscan/presentation/screens/register_screen.dart';
import 'package:beautyscan/presentation/screens/home_screen.dart';
import 'package:beautyscan/presentation/screens/scanner_screen.dart';
import 'package:beautyscan/presentation/screens/analysis_screen.dart';
import 'package:beautyscan/presentation/screens/analysis_results_screen.dart';
import 'package:beautyscan/presentation/screens/gallery_screen.dart';
import 'package:beautyscan/presentation/screens/hairstyle_processing_screen.dart';
import 'package:beautyscan/presentation/screens/hairstyle_display_screen.dart';
import 'package:beautyscan/presentation/screens/history_screen.dart';
import 'package:beautyscan/presentation/screens/profile_screen.dart';
import 'package:beautyscan/presentation/screens/settings_screen.dart';
import 'package:beautyscan/presentation/screens/hairstyle_detail_screen.dart';
import 'package:beautyscan/presentation/screens/colorimetry_detail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  Gemini.init(apiKey: dotenv.env['API_KEY'] ?? '');
  runApp(const BeautyScanApp());
}

class BeautyScanApp extends StatelessWidget {
  const BeautyScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeautyScan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (c) => const SplashScreen(),
        '/onboarding': (c) => const OnboardingScreen(),
        '/login': (c) => const LoginScreen(),
        '/register': (c) => const RegisterScreen(),
        '/home': (c) => const HomeScreen(),
        '/scanner': (c) => const ScannerScreen(),
        '/analysis': (c) => const AnalysisScreen(),
        '/analysis_results': (c) => const AnalysisResultsScreen(),
        '/gallery': (c) => const GalleryScreen(),
        '/hairstyle_processing': (c) => const HairstyleProcessingScreen(),
        '/hairstyle_display': (c) => const HairstyleDisplayScreen(),
        '/history': (c) => const HistoryScreen(),
        '/profile': (c) => const ProfileScreen(),
        '/settings': (c) => const SettingsScreen(),
        '/hairstyle_detail': (c) => const HairstyleDetailScreen(),
        '/colorimetry_detail': (c) => const ColorimetryDetailScreen(),
      },
    );
  }
}
