import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
      appBar: AppBar(title: const Text('Scanner')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Camera/Scanner View'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/analysis'),
              child: const Text('Capture & Analyze'),
            ),
          ],
        ),
      ),
    ));
  }
}
