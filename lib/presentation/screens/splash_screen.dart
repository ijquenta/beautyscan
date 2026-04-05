import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Splash Screen', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/onboarding'),
              child: const Text('Go to Onboarding'),
            ),
          ],
        ),
      ),
    ));
  }
}
