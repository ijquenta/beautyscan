import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('History')),
        body: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.history),
              title: Text('Analysis ${index + 1}'),
              subtitle: const Text('Tap to view details'),
              onTap: () => Navigator.pushNamed(context, '/analysis_results'),
            );
          },
        ),
      ),
    );
  }
}
