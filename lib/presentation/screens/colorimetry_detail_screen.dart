import 'package:flutter/material.dart';
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
            child: const Padding(
              padding: EdgeInsets.only(left: 32, top: 20),
              child: Text(
                'VOLVER',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          leadingWidth: 100,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado Editorial
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'TEMPORADA',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                          color: Colors.black38,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Primavera\nCálida.',
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 56,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: -1.0,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Colores brillantes, cálidos y saturados\nque reflejan tu vitalidad natural.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.black54,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Características Tipograficas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCharacteristic('SUBTONO', 'Cálido dorado'),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildCharacteristic('CONTRASTE', 'Medio bajo'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCharacteristic('SATURACIÓN', 'Alta – Viva'),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildCharacteristic('VALOR', 'Claro medio'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Paletas de Color en bloques precisos
                _buildSectionTitle('FAVORECEDORES'),
                const SizedBox(height: 24),
                _buildPaletteRow([
                  Color(0xFFE8936A), Color(0xFFD4845A), Color(0xFFBF6A3A),
                  Color(0xFFE8C060), Color(0xFFD4A840),
                ], 'TERRACOTA Y MELOCOTÓN'),
                const SizedBox(height: 24),
                _buildPaletteRow([
                  Color(0xFF8BAE50), Color(0xFF6E9040), Color(0xFF4A9E8C),
                  Color(0xFF3A8070), Color(0xFFE8D080),
                ], 'VERDE OLIVA Y TURQUESA'),

                const SizedBox(height: 48),

                _buildSectionTitle('A EVITAR'),
                const SizedBox(height: 24),
                _buildPaletteRow([
                  Color(0xFF6080B0), Color(0xFF4060A0), Color(0xFF203870),
                  Color(0xFF607890), Color(0xFF405870),
                ], 'AZULES FRÍOS Y GRIS AZULADO', isAvoid: true),

                const SizedBox(height: 48),

                // Tips de moda
                _buildSectionTitle('TIPS DE MODA'),
                const SizedBox(height: 24),
                ...[
                  'Opta por telas con brillo suave como seda o satén en tonos cálidos.',
                  'Los estampados en tonos tierra y dorados son tus aliados.',
                  'Evita el negro en zonas cercanas al rostro; sustitúyelo por marrón.',
                  'El dorado es tu metal ideal en accesorios.',
                ].map((tip) => _buildTipRow(tip)),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 3.0,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCharacteristic(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 9,
            letterSpacing: 2.0,
            color: Colors.black45,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPaletteRow(List<Color> colors, String label, {bool isAvoid = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: colors.map((c) => Expanded(
              child: Container(
                height: 40,
                color: c,
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 9,
              letterSpacing: 2.0,
              color: isAvoid ? Colors.black87 : Colors.black54,
              fontWeight: isAvoid ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '—',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
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
        ],
      ),
    );
  }
}
