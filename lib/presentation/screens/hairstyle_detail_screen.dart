import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';
import '../../domain/models/hairstyle_model.dart';

class HairstyleDetailScreen extends StatefulWidget {
  const HairstyleDetailScreen({super.key});

  @override
  State<HairstyleDetailScreen> createState() => _HairstyleDetailScreenState();
}

class _HairstyleDetailScreenState extends State<HairstyleDetailScreen> {
  HairstyleModel? _style;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is HairstyleModel) {
      _style = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fallback al bob texturizado si no se pasa argumento
    final style = _style ?? HairstyleModel.catalog[2];

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
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Estilo compartido.',
                        style: TextStyle(fontFamily: 'Inter')),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
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
                // ── Encabezado ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ESTILO SIMULADO IA',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                          color: Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        style.name,
                        style: const TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 52,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: -1.0,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        style.description,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.black54,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Características ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCharacteristic(
                            'TIPO', _capitalize(style.styleType)),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildCharacteristic(
                            'MANTENIMIENTO', style.maintenanceLevel),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCharacteristic('ESTILO',
                            style.styleType == 'rizado' ? 'Texturizado' : 'Liso/Ondulado'),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildCharacteristic(
                            'TECNOLOGÍA', 'Simulación IA'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // ── Productos / Herramientas ──────────────────────────────
                _buildSectionTitle('PRODUCTOS / HERRAMIENTAS'),
                const SizedBox(height: 24),
                ...style.products.map((p) => _buildProductRow(p)),

                const SizedBox(height: 48),

                // ── Guía del Estilista ────────────────────────────────────
                _buildSectionTitle('GUÍA PARA EL ESTILISTA'),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: style.stylistSteps.asMap().entries.map((e) {
                      final romanNumerals = ['I.', 'II.', 'III.', 'IV.', 'V.'];
                      final num = e.key < romanNumerals.length
                          ? romanNumerals[e.key]
                          : '${e.key + 1}.';
                      return _InstructionStep(number: num, text: e.value);
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 48),

                // ── Botón de Acción ───────────────────────────────────────
                GestureDetector(
                  onTap: () => Navigator.popUntil(
                      context, ModalRoute.withName('/home')),
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

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

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

  Widget _buildProductRow(HairstyleProduct item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.black12, width: 1.0)),
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
