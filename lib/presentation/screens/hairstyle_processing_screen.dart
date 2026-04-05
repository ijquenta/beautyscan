import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class HairstyleProcessingScreen extends StatelessWidget {
  const HairstyleProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Processing Hairstyle')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('Applying style using AI...'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  '/hairstyle_display',
                ),
                child: const Text('Finish Processing (Mock)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
