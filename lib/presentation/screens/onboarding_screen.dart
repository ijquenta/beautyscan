import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('Onboarding')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Onboarding Steps...'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Go to Login'),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/register'),
                child: const Text('Go to Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
