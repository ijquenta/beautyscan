import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola,',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Bienvenida',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.whiteGlassmorphism,
                            border: Border.all(color: Colors.white70, width: 1.5),
                            boxShadow: const [
                              BoxShadow(color: AppColors.shadowGlow, blurRadius: 12),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'U',
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primaryAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Hero Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: AppConstants.largeCardRadius,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFC2547A), Color(0xFFD4729A)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryAccent.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Circulo decorativo
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 30,
                          bottom: -30,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Descubre tu\nesencia beauty',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: AppConstants.pillBorderRadius,
                                ),
                                child: const Text(
                                  'Iniciar escaneo',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.primaryAccent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
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
              ),

              // Acciones Rápidas
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Text(
                    'Acciones rápidas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildListDelegate([
                    _QuickActionCard(
                      label: 'Escanear',
                      subtitle: 'Analiza tu rostro',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFDE8F0), Color(0xFFFFD6E8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      accentColor: AppColors.primaryAccent,
                      onTap: () => Navigator.pushNamed(context, '/scanner'),
                    ),
                    _QuickActionCard(
                      label: 'Galería',
                      subtitle: 'Tus fotos',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8E0F5), Color(0xFFD4C8F0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      accentColor: Color(0xFF7C5CBF),
                      onTap: () => Navigator.pushNamed(context, '/gallery'),
                    ),
                    _QuickActionCard(
                      label: 'Historial',
                      subtitle: 'Análisis anteriores',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE0EEFF), Color(0xFFC8DCFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      accentColor: Color(0xFF3A6FD8),
                      onTap: () => Navigator.pushNamed(context, '/history'),
                    ),
                    _QuickActionCard(
                      label: 'Perfil',
                      subtitle: 'Tu información',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF0E0), Color(0xFFFFDEC8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      accentColor: Color(0xFFD4721A),
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                    ),
                  ]),
                ),
              ),

              // Últimos análisis
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Últimos análisis',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/history'),
                        child: const Text(
                          'Ver todos',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _RecentAnalysisCard(
                      type: 'Colorimetría',
                      result: 'Primavera Cálida',
                      date: 'Hace 2 días',
                      badgeColor: const Color(0xFFC2547A),
                      onTap: () => Navigator.pushNamed(context, '/analysis_results'),
                    ),
                    const SizedBox(height: 12),
                    _RecentAnalysisCard(
                      type: 'Peinado IA',
                      result: 'Bob Texturizado',
                      date: 'Hace 5 días',
                      badgeColor: const Color(0xFF7C5CBF),
                      onTap: () => Navigator.pushNamed(context, '/hairstyle_display'),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final LinearGradient gradient;
  final Color accentColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: AppConstants.defaultCardRadius,
          border: Border.all(color: Colors.white70, width: 1),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: accentColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentAnalysisCard extends StatelessWidget {
  final String type;
  final String result;
  final String date;
  final Color badgeColor;
  final VoidCallback onTap;

  const _RecentAnalysisCard({
    required this.type,
    required this.result,
    required this.date,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteGlassmorphism,
          borderRadius: AppConstants.defaultCardRadius,
          border: Border.all(color: Colors.white60, width: 1),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowGlow, blurRadius: 12),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: badgeColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    result,
                    style: const TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Colors.black38,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: Colors.black26, size: 20),
          ],
        ),
      ),
    );
  }
}
