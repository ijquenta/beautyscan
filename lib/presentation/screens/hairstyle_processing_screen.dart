import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';
import '../../domain/models/hairstyle_model.dart';

class HairstyleProcessingScreen extends StatefulWidget {
  const HairstyleProcessingScreen({super.key});

  @override
  State<HairstyleProcessingScreen> createState() => _HairstyleProcessingScreenState();
}

class _HairstyleProcessingScreenState extends State<HairstyleProcessingScreen> {
  int _selectedIndex = 2; // Default bob texturizado
  final List<HairstyleModel> _styles = HairstyleModel.catalog;

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.only(left: 24, top: 20),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_rounded, size: 18, color: Colors.black54),
                    SizedBox(width: 6),
                    Text('Volver', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54)),
                  ],
                ),
              ),
            ),
          ),
          leadingWidth: 100,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Catálogo.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -1.0,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Elige un estilo para la simulación fotorrealista.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black54,
                    height: 1.6,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 48),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _styles.length,
                  itemBuilder: (context, index) {
                    final style = _styles[index];
                    final isSelected = index == _selectedIndex;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.black87 : Colors.black12,
                            width: isSelected ? 2 : 1,
                          ),
                          image: DecorationImage(
                            image: AssetImage(style.imagePath),
                            fit: BoxFit.cover,
                            colorFilter: isSelected ? null : ColorFilter.mode(
                              Colors.white.withValues(alpha: 0.3),
                              BlendMode.lighten,
                            ),
                          ),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: isSelected ? style.accentColor : Colors.white.withValues(alpha: 0.5),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? Colors.transparent : Colors.white54,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    style.name.replaceAll('\\n', ' '),
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    style.styleType.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 9,
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: GestureDetector(
                  onTap: () {
                    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                    final originalPhotoPath = args?['photoPath'] as String?;

                    if (originalPhotoPath == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error: No photo provided.')),
                      );
                      return;
                    }

                    Navigator.pushNamed(
                      context,
                      '/hairstyle_loading',
                      arguments: {
                        'style': _styles[_selectedIndex],
                        'photoPath': originalPhotoPath,
                        'colorimetry': args?['colorimetry'],
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: AppColors.negroCarbon,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'Simular peinado',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
