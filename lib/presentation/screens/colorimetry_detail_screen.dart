import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class ColorimetryDetailScreen extends StatelessWidget {
  const ColorimetryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
      appBar: AppBar(title: const Text('Colorimetry Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Color palette and analysis...'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    ));
  }
}
