import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Gallery Grid View'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/hairstyle_processing'),
              child: const Text('Select Photo & Try Hairstyle'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/analysis'),
              child: const Text('Select Photo & Analyze Face'),
            ),
          ],
        ),
      ),
    ));
  }
}
