import 'package:flutter/material.dart';
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
          actions: [
            GestureDetector(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.only(right: 32, top: 20),
                child: Text(
                  'COMPARTIR',
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
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ESTILO SIMULADO IA',
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
                        'Texturizado\nCaoba Cálida.',
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 52,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: -1.0,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Corte bob con capas texturizadas y un tinte\ncaoba cálido que realza tu temporada natural.',
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

                // Specs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCharacteristic('TIPO', 'Bob Corte'),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildCharacteristic('LARGO', 'Medio corto'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCharacteristic('TEXTURA', 'Ondulado'),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildCharacteristic('MANTENIMIENTO', 'Moderado'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Recomendados
                _buildSectionTitle('PRODUCTOS / HERRAMIENTAS'),
                const SizedBox(height: 24),
                ..._ProductItem.samples.map(
                  (p) => _buildProductRow(p),
                ),

                const SizedBox(height: 48),

                // Pasos estilista
                _buildSectionTitle('GUÍA PARA EL ESTILISTA'),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: const [
                      _InstructionStep(
                        number: 'I.',
                        text: 'Decoloración en mechones superiores pre-tinte.',
                      ),
                      _InstructionStep(
                        number: 'II.',
                        text: 'Tinte 6.45 (caoba cálido) por toda la longitud (35 min).',
                      ),
                      _InstructionStep(
                        number: 'III.',
                        text: 'Corte bob, altura del mentón con capas internas.',
                      ),
                      _InstructionStep(
                        number: 'IV.',
                        text: 'Ondas con plancha 32mm, finalizando con aceite argán.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                GestureDetector(
                  onTap: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
                  child: Container(
                    width: double.infinity,
                    color: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: const Center(
                      child: Text(
                        'GUARDAR ESTILO',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Colors.white,
                        ),
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

  Widget _buildProductRow(_ProductItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 1.0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 1.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
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
          Text(
            item.use.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.black87,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(
              number,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontWeight: FontWeight.w400,
                fontSize: 32,
                color: Colors.black26,
                height: 1,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
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

  const _ProductItem({
    required this.name,
    required this.brand,
    required this.use,
  });

  static const List<_ProductItem> samples = [
    _ProductItem(name: '6.45 CAOBA', brand: 'Koleston Perfect', use: 'Tinte'),
    _ProductItem(name: 'MASCARILLA', brand: 'Kerastase Nutritive', use: 'Reparador'),
    _ProductItem(name: 'ACEITE ARGÁN', brand: 'Moroccanoil', use: 'Acabado'),
  ];
}
