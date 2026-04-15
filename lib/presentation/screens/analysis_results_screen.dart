import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';

class AnalysisResultsScreen extends StatelessWidget {
  const AnalysisResultsScreen({super.key});

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
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.whiteGlassmorphism,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white60, width: 1),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.black87, size: 20),
            ),
          ),
          title: Text(
            'Resultados',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlassmorphism,
                    borderRadius: AppConstants.pillBorderRadius,
                    border: Border.all(color: Colors.white60, width: 1),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge resultado general
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC2547A), Color(0xFFD4729A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppConstants.largeCardRadius,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Tu temporada de color',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Primavera\nCálida',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tonos cálidos y vibrantes que realzan\ntu luminosidad natural',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Fila de métricas
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: 'Forma del rostro',
                        value: 'Ovalado',
                        color: const Color(0xFF7C5CBF),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        label: 'Subtono de piel',
                        value: 'Cálido',
                        color: const Color(0xFFD4721A),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: 'Contraste',
                        value: 'Medio',
                        color: const Color(0xFF3A6FD8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        label: 'Intensidad',
                        value: 'Suave',
                        color: const Color(0xFF2E9E6E),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Sección paleta de colores
                Text(
                  'Tu paleta de colores',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlassmorphism,
                    borderRadius: AppConstants.defaultCardRadius,
                    border: Border.all(color: Colors.white60, width: 1),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadowGlow, blurRadius: 12),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _ColorSwatch(color: Color(0xFFE8936A)),
                      _ColorSwatch(color: Color(0xFFD4845A)),
                      _ColorSwatch(color: Color(0xFFC2547A)),
                      _ColorSwatch(color: Color(0xFFE8C060)),
                      _ColorSwatch(color: Color(0xFF8BAE50)),
                      _ColorSwatch(color: Color(0xFF4A9E8C)),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Acciones
                Text(
                  'Explorar más',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                _ActionTile(
                  title: 'Ver análisis de colorimetría',
                  subtitle: 'Paleta completa y recomendaciones',
                  color: const Color(0xFFC2547A),
                  onTap: () => Navigator.pushNamed(context, '/colorimetry_detail'),
                ),
                const SizedBox(height: 10),
                _ActionTile(
                  title: 'Simular nuevo peinado',
                  subtitle: 'Prueba estilos con IA',
                  color: const Color(0xFF7C5CBF),
                  onTap: () => Navigator.pushNamed(context, '/hairstyle_processing'),
                ),
                const SizedBox(height: 10),
                _ActionTile(
                  title: 'Volver al inicio',
                  subtitle: 'Panel principal',
                  color: const Color(0xFF3A6FD8),
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteGlassmorphism,
        borderRadius: AppConstants.defaultCardRadius,
        border: Border.all(color: Colors.white60, width: 1),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowGlow, blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  const _ColorSwatch({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.color,
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
            BoxShadow(color: AppColors.shadowGlow, blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color.withValues(alpha: 0.6), size: 22),
          ],
        ),
      ),
    );
  }
}
