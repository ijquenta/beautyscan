import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Analysis in Progress')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('Analyzing face and hair...'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  '/analysis_results',
                ),
                child: const Text('Finish Analysis (Mock)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
