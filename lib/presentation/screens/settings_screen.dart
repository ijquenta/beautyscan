import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('App Preferences'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/feedback'),
                child: const Text('Help / Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
