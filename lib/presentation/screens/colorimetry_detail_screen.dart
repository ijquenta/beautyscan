import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';

class ColorimetryDetailScreen extends StatelessWidget {
  const ColorimetryDetailScreen({super.key});

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
            'Colorimetría',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado de temporada
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE8936A), Color(0xFFC2547A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppConstants.largeCardRadius,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE8936A).withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Temporada',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                        'Colores brillantes, cálidos y saturados\nque reflejan tu vitalidad natural',
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

                const SizedBox(height: 28),

                // Características
                Text(
                  'Tus características',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _CharacteristicCard(
                        label: 'Subtono',
                        value: 'Cálido dorado',
                        dotColor: const Color(0xFFE8936A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CharacteristicCard(
                        label: 'Contraste',
                        value: 'Medio bajo',
                        dotColor: const Color(0xFFD4845A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _CharacteristicCard(
                        label: 'Saturación',
                        value: 'Alta – Viva',
                        dotColor: const Color(0xFF8BAE50),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CharacteristicCard(
                        label: 'Valor',
                        value: 'Claro medio',
                        dotColor: const Color(0xFF4A9E8C),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Paleta favorece
                Text(
                  'Colores que te favorecen',
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
                  child: Column(
                    children: const [
                      _PaletteRow(
                        colors: [
                          Color(0xFFE8936A),
                          Color(0xFFD4845A),
                          Color(0xFFBF6A3A),
                          Color(0xFFE8C060),
                          Color(0xFFD4A840),
                        ],
                        label: 'Terracota y melocotón',
                      ),
                      SizedBox(height: 16),
                      _PaletteRow(
                        colors: [
                          Color(0xFF8BAE50),
                          Color(0xFF6E9040),
                          Color(0xFF4A9E8C),
                          Color(0xFF3A8070),
                          Color(0xFFE8D080),
                        ],
                        label: 'Verde oliva y turquesa cálido',
                      ),
                      SizedBox(height: 16),
                      _PaletteRow(
                        colors: [
                          Color(0xFFC2547A),
                          Color(0xFFD4729A),
                          Color(0xFFE890B0),
                          Color(0xFFBF4060),
                          Color(0xFFA83050),
                        ],
                        label: 'Rosa coral y fucsia suave',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Colores a evitar
                Text(
                  'Colores a evitar',
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
                  child: Column(
                    children: const [
                      _PaletteRow(
                        colors: [
                          Color(0xFF6080B0),
                          Color(0xFF4060A0),
                          Color(0xFF203870),
                          Color(0xFF607890),
                          Color(0xFF405870),
                        ],
                        label: 'Azules fríos y gris azulado',
                        avoid: true,
                      ),
                      SizedBox(height: 16),
                      _PaletteRow(
                        colors: [
                          Color(0xFF282828),
                          Color(0xFF181818),
                          Color(0xFFF8F8F8),
                          Color(0xFFD0D8E0),
                          Color(0xFFA8B8C8),
                        ],
                        label: 'Negro puro, blanco frío y grises fríos',
                        avoid: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Recomendaciones de ropa
                Text(
                  'Tips de moda',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                ...[
                  'Opta por telas con brillo suave como seda o satén en tonos cálidos.',
                  'Los estampados en tonos tierra y dorados son tus aliados.',
                  'Evita el negro en zonas cercanas al rostro; sustitúyelo por marrón oscuro.',
                  'El dorado es tu metal ideal en accesorios.',
                ].map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.whiteGlassmorphism,
                        borderRadius: AppConstants.defaultCardRadius,
                        border: Border.all(color: Colors.white60, width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryAccent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _CharacteristicCard extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;

  const _CharacteristicCard({
    required this.label,
    required this.value,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteGlassmorphism,
        borderRadius: AppConstants.defaultCardRadius,
        border: Border.all(color: Colors.white60, width: 1),
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
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaletteRow extends StatelessWidget {
  final List<Color> colors;
  final String label;
  final bool avoid;

  const _PaletteRow({
    required this.colors,
    required this.label,
    this.avoid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: colors
              .map(
                (c) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: c.withValues(alpha: 0.25),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: avoid ? const Color(0xFFBF4040) : Colors.black45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
