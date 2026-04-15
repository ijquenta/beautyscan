import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';

class HairstyleDetailScreen extends StatelessWidget {
  const HairstyleDetailScreen({super.key});

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
            'Detalle del estilo',
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
                    'Compartir',
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
                // Nombre y descripción
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C5CBF), Color(0xFF9E7AD4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppConstants.largeCardRadius,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C5CBF).withValues(alpha: 0.35),
                        blurRadius: 24,
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
                          'Estilo simulado con IA',
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
                        'Bob Texturizado\nCaoba Cálida',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Corte bob con capas texturizadas y un\ntinte caoba cálido que realza tu temporada',
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

                // Detalles del estilo
                Text(
                  'Características del estilo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _StyleBadge(label: 'Tipo', value: 'Bob Corte'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StyleBadge(label: 'Largo', value: 'Medio corto'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StyleBadge(label: 'Textura', value: 'Ondulado'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StyleBadge(label: 'Mantenimiento', value: 'Moderado'),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Productos recomendados
                Text(
                  'Productos recomendados',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                ..._ProductItem.samples.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ProductCard(item: p),
                  ),
                ),

                const SizedBox(height: 28),

                // Pasos para el estilista
                Text(
                  'Instrucciones para el estilista',
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
                      _InstructionStep(
                        number: '01',
                        text: 'Aplicar decoloración en mechones superiores para preparar el cabello al tinte caoba.',
                      ),
                      SizedBox(height: 16),
                      _InstructionStep(
                        number: '02',
                        text: 'Aplicar tinte 6.45 (caoba cálido) por toda la longitud, dejar actuar 35 minutos.',
                      ),
                      SizedBox(height: 16),
                      _InstructionStep(
                        number: '03',
                        text: 'Cortar en bob a la altura del mentón con capas internas para agregar volumen y textura.',
                      ),
                      SizedBox(height: 16),
                      _InstructionStep(
                        number: '04',
                        text: 'Definir ondas con plancha de 32mm y finalizar con aceite de argán para brillo.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Botón guardar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.popUntil(
                      context,
                      ModalRoute.withName('/home'),
                    ),
                    child: const Text('Guardar estilo'),
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

class _StyleBadge extends StatelessWidget {
  final String label;
  final String value;

  const _StyleBadge({required this.label, required this.value});

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
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductItem {
  final String name;
  final String brand;
  final String use;
  final Color color;

  const _ProductItem({
    required this.name,
    required this.brand,
    required this.use,
    required this.color,
  });

  static const List<_ProductItem> samples = [
    _ProductItem(
      name: 'Tinte 6.45 Caoba',
      brand: 'Koleston Perfect',
      use: 'Coloración permanente',
      color: Color(0xFFBF6A3A),
    ),
    _ProductItem(
      name: 'Mascarilla Reparadora',
      brand: 'Kerastase Nutritive',
      use: 'Tratamiento post-color',
      color: Color(0xFF7C5CBF),
    ),
    _ProductItem(
      name: 'Aceite de Argán',
      brand: 'Moroccanoil',
      use: 'Acabado y brillo',
      color: Color(0xFFD4721A),
    ),
  ];
}

class _ProductCard extends StatelessWidget {
  final _ProductItem item;
  const _ProductCard({required this.item});

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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.color,
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
                  item.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.brand,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.use,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: item.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  final String number;
  final String text;
  const _InstructionStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.primaryAccent,
            height: 1,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
