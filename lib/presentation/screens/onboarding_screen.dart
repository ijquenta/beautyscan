import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Padding(
                padding: EdgeInsets.only(right: 32, top: 20),
                child: Text(
                  'OMITIR',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildPage(
                      title: 'Descubre tu\ncolorimetría.',
                      subtitle: 'Analizamos tu piel con IA para brindarte tu paleta cromática ideal.',
                      graphicNumber: '01',
                    ),
                    _buildPage(
                      title: 'Simula nuevos\npeinados.',
                      subtitle: 'Experimenta diferentes estilos y cortes de cabello arquitectónicos.',
                      graphicNumber: '02',
                    ),
                    _buildPage(
                      title: 'Asesoramiento\nabsoluto.',
                      subtitle: 'Recomendaciones perfectas basadas en métricas de alta precisión.',
                      graphicNumber: '03',
                    ),
                  ],
                ),
              ),
              
              // Footer
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(isActive: _currentPage == 0),
                      const SizedBox(width: 8),
                      _buildDot(isActive: _currentPage == 1),
                      const SizedBox(width: 8),
                      _buildDot(isActive: _currentPage == 2),
                    ],
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _onNextPressed,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      color: Colors.black87,
                      child: Center(
                        child: Text(
                          _currentPage == 2 ? 'COMENZAR' : 'SIGUIENTE',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String subtitle, required String graphicNumber}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              graphicNumber,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 64,
                fontWeight: FontWeight.w400,
                color: Colors.black12,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.1,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                height: 1.6,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 32.0 : 16.0,
      height: 1.5,
      color: isActive ? Colors.black87 : Colors.black12,
    );
  }
}
