import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class AnalysisResultsScreen extends StatelessWidget {
  const AnalysisResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Analysis Results')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Diagnosis Results Summary'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/colorimetry_detail'),
                child: const Text('View Colorimetry Details'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/hairstyle_processing'),
                child: const Text('Try New Hairstyle'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
