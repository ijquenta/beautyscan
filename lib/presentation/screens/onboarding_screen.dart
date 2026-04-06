import 'dart:ui';
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

  final Color textColor = const Color(0xFF23181E);
  final Color textVariantColor = const Color(0xFF554246);

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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Omitir',
                style: TextStyle(
                  color: AppColors.primaryAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(width: 16),
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
                    // Página 1: Colorimetría
                    _buildPage(
                      title: 'Descubre tu colorimetría',
                      subtitle: 'Analizamos tu tono de piel con IA para darte tu paleta de colores ideal',
                      graphic: _buildGraphicIllustration(
                        icon: Icons.face_retouching_natural,
                        showScanner: true,
                      ),
                    ),
                    // Página 2: Peinados
                    _buildPage(
                      title: 'Simula nuevos peinados',
                      subtitle: 'Prueba diferentes estilos y tintes sin salir de casa mediante inteligencia artificial.',
                      graphic: _buildGraphicIllustration(
                        icon: Icons.face_3,
                        showScanner: false,
                      ),
                    ),
                    // Página 3: Resultados IA
                    _buildPage(
                      title: 'Asesoramiento instantáneo',
                      subtitle: 'Obtén recomendaciones personalizadas basadas en tus escaneos para brillar.',
                      graphic: _buildGraphicIllustration(
                        icon: Icons.auto_awesome,
                        showScanner: false,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Footer
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    // Page Indicators
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
                    const SizedBox(height: 32),
                    // Siguiente Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                          shadowColor: AppColors.primaryAccent.withValues(alpha: 0.4),
                        ),
                        onPressed: _onNextPressed,
                        child: Text(
                          _currentPage == 2 ? 'Comenzar' : 'Siguiente',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String subtitle, required Widget graphic}) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            graphic,
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      letterSpacing: -1.0,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textVariantColor,
                      height: 1.5,
                    ),
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
      width: isActive ? 24.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryAccent : AppColors.primaryAccent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildGraphicIllustration({required IconData icon, required bool showScanner}) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryAccent.withValues(alpha: 0.15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.15),
                  blurRadius: 80,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.4),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent.withValues(alpha: 0.08),
                      offset: const Offset(0, 20),
                      blurRadius: 50,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 130,
                      color: AppColors.primaryAccent.withValues(alpha: 0.7),
                    ),
                    if (showScanner)
                      CustomPaint(
                        size: const Size(130, 130),
                        painter: _ScannerPainter(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = AppColors.primaryAccent.withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
      
    final paintNode = Paint()
      ..color = AppColors.primaryAccent
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final nodeRadius = 3.0;

    final centerNode = Offset(cx, cy);
    final topLeftNode = Offset(cx * 0.35, cy * 0.35);
    final topRightNode = Offset(cx * 1.65, cy * 0.35);
    final bottomLeftNode = Offset(cx * 0.35, cy * 1.65);
    final bottomRightNode = Offset(cx * 1.65, cy * 1.65);

    final path = Path();
    path.moveTo(topLeftNode.dx, topLeftNode.dy);
    path.quadraticBezierTo(cx * 0.5, cy * 0.8, centerNode.dx, centerNode.dy);
    
    path.moveTo(centerNode.dx, centerNode.dy);
    path.quadraticBezierTo(cx * 1.5, cy * 1.2, bottomRightNode.dx, bottomRightNode.dy);
    
    path.moveTo(topRightNode.dx, topRightNode.dy);
    path.quadraticBezierTo(cx * 1.5, cy * 0.6, centerNode.dx, centerNode.dy);

    path.moveTo(bottomLeftNode.dx, bottomLeftNode.dy);
    path.quadraticBezierTo(cx * 0.5, cy * 1.4, centerNode.dx, centerNode.dy);

    canvas.drawPath(path, paintLine);

    canvas.drawCircle(centerNode, nodeRadius, paintNode);
    canvas.drawCircle(topLeftNode, nodeRadius, paintNode);
    canvas.drawCircle(topRightNode, nodeRadius, paintNode);
    canvas.drawCircle(bottomLeftNode, nodeRadius, paintNode);
    canvas.drawCircle(bottomRightNode, nodeRadius, paintNode);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
