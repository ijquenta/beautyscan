import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';
import '../../core/constants.dart';
import '../components/organisms/before_after_slider.dart';

class HairstyleDisplayScreen extends StatelessWidget {
  const HairstyleDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Simulación IA'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Comparador Wipeo
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowGlow,
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                      borderRadius: AppConstants.largeCardRadius,
                    ),
                    // Imágenes Hardcodeadas públicas de Unsplash
                    // Simulando Antes (Mujer rubia) y Después (Castaña editada)
                    child: const BeforeAfterSlider(
                      beforeImage: NetworkImage(
                        'https://images.unsplash.com/photo-1549471013-3364d7ce4668?auto=format&fit=crop&q=80&w=800',
                      ),
                      afterImage: NetworkImage(
                        'https://images.unsplash.com/photo-1580618672591-eb180b1a973f?auto=format&fit=crop&q=80&w=800',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Feedback chat / Ajustes a la IA
                Text(
                  '¿Ajustar simulación?',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Ej: Hazlo un poco más oscuro...',
                          hintStyle: TextStyle(color: Colors.black38),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primaryAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppColors.shadowGlow, blurRadius: 8),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Acción de envío al prompt del chat de Gemini
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Botones Finales
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryAccent,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/hairstyle_detail'),
                      child: const Text('Ver Detalles'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.popUntil(
                        context,
                        ModalRoute.withName('/home'),
                      ),
                      child: const Text('Guardar Resultado'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
