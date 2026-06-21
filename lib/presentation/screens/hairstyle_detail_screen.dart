import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';
import '../../core/constants.dart';
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
              child: Row(
                children: [
                  Icon(Icons.arrow_back_rounded, size: 18, color: Colors.black54),
                  SizedBox(width: 4),
                  Text('Volver', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
          ),
          leadingWidth: 120,
          actions: [
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.negroCarbon,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    content: const Text('Estilo compartido.', style: TextStyle(fontFamily: 'Poppins')),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 32, top: 20),
                child: Row(
                  children: [
                    Icon(Icons.ios_share_rounded, size: 16, color: Colors.black54),
                    SizedBox(width: 4),
                    Text('Compartir', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black54)),
                  ],
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 12, 32, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.negroCarbon.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Estilo simulado con IA', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: Colors.black45)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        style.name,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 44, fontWeight: FontWeight.w700, color: AppColors.negroCarbon, letterSpacing: -1.0, height: 1.0),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        style.description,
                        style: const TextStyle(fontFamily: 'Poppins', color: Colors.black54, fontSize: 14, height: 1.6),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                    child: Column(
                      children: [
                        _buildCharacteristicRow(Icons.category_outlined, 'Tipo', style.styleType == 'rizado' ? 'Texturizado' : 'Liso/Ondulado'),
                        const Divider(height: 20, color: Colors.black12),
                        _buildCharacteristicRow(Icons.tune_outlined, 'Mantenimiento', style.maintenanceLevel),
                        const Divider(height: 20, color: Colors.black12),
                        _buildCharacteristicRow(Icons.auto_awesome_outlined, 'Tecnología', 'Simulación IA'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 44),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Container(
                        width: 3, height: 14,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: AppColors.negroCarbon.withValues(alpha: 0.3)),
                      ),
                      const SizedBox(width: 10),
                      const Text('Productos / Herramientas', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                    child: Column(
                      children: style.products.map((p) => _buildProductRow(p)).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 44),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Container(
                        width: 3, height: 14,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: AppColors.negroCarbon.withValues(alpha: 0.3)),
                      ),
                      const SizedBox(width: 10),
                      const Text('Guía para el estilista', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                    child: Column(
                      children: style.stylistSteps.asMap().entries.map((e) {
                        final romanNumerals = ['I.', 'II.', 'III.', 'IV.', 'V.'];
                        final num = e.key < romanNumerals.length ? romanNumerals[e.key] : '${e.key + 1}.';
                        return _InstructionStep(number: num, text: e.value);
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                GestureDetector(
                  onTap: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
                  child: Container(
                    width: double.infinity,
                    color: AppColors.negroCarbon,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_outlined, size: 16, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Guardar estilo', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
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

  Widget _buildCharacteristicRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: AppColors.negroCarbon.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: Colors.black45),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black45)),
        ),
        Text(value, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.negroCarbon)),
      ],
    );
  }

  Widget _buildProductRow(HairstyleProduct item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.negroCarbon)),
                const SizedBox(height: 2),
                Text(item.brand, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black45)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.negroCarbon.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(item.use, style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: Colors.black45)),
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
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Text(
              number,
              style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 28, color: Colors.black26, height: 1),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                text,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black87, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
