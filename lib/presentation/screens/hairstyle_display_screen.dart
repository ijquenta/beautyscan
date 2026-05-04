import 'dart:io';
import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';
import '../components/organisms/before_after_slider.dart';
import '../../domain/models/hairstyle_model.dart';

class HairstyleDisplayScreen extends StatefulWidget {
  const HairstyleDisplayScreen({super.key});

  @override
  State<HairstyleDisplayScreen> createState() => _HairstyleDisplayScreenState();
}

class _HairstyleDisplayScreenState extends State<HairstyleDisplayScreen> {
  String? _originalPhotoPath;
  String? _photoPath; // Nuevo path generado
  HairstyleModel? _style;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recibir el modelo de peinado seleccionado en el carrusel y las rutas
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _style = args['style'] as HairstyleModel?;
      _photoPath = args['photoPath'] as String?;
      _originalPhotoPath = args['originalPhotoPath'] as String?;
    } else if (args is HairstyleModel) {
      _style = args;
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final photoPath = _photoPath;
    final originalPath = _originalPhotoPath;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EL RESULTADO',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                        color: Colors.black38,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Título dinámico según el estilo seleccionado
                    Text(
                      style != null
                          ? style.name.replaceAll('\n', ' ')
                          : 'Simulación.',
                      style: const TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: -1.0,
                        height: 1.0,
                      ),
                    ),
                    if (style != null) ...[
                      const SizedBox(height: 6),
                      // Chips de metadata del estilo
                      Row(
                        children: [
                          _MetaChip(label: style.styleType.toUpperCase()),
                          const SizedBox(width: 12),
                          _MetaChip(
                              label:
                                  'MANTENIMIENTO ${style.maintenanceLevel.toUpperCase()}'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Imagen comparativa (before/after)
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: BeforeAfterSlider(
                    beforeImage: originalPath != null
                        ? FileImage(File(originalPath)) as ImageProvider
                        : const NetworkImage(
                            'https://images.unsplash.com/photo-1549471013-3364d7ce4668?auto=format&fit=crop&q=80&w=800',
                          ),
                    afterImage: photoPath != null
                        ? FileImage(File(photoPath)) as ImageProvider
                        : const NetworkImage(
                            'https://images.unsplash.com/photo-1580618672591-eb180b1a973f?auto=format&fit=crop&q=80&w=800',
                          ),
                  ),
                ),
              ),

              // Feedback adjustment field
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 28, 32, 0),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 1.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _feedbackController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'AJUSTAR (EJ: MÁS OSCURO)',
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              letterSpacing: 2.0,
                              color: Colors.black38,
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            letterSpacing: 2.0,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Future: re-trigger IA with _feedbackController.text
                          _feedbackController.clear();
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ajuste enviado.',
                                  style: TextStyle(fontFamily: 'Inter')),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Text(
                          'ENVIAR',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Acción: Ver detalles completos
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/hairstyle_detail',
                  arguments: style,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border:
                        Border(top: BorderSide(color: Colors.black12, width: 1)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: const Center(
                    child: Text(
                      'VER DETALLES COMPLETOS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.popUntil(
                    context, ModalRoute.withName('/home')),
                child: Container(
                  width: double.infinity,
                  color: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: const Center(
                    child: Text(
                      'GUARDAR RESULTADO',
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
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  const _MetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 8,
          letterSpacing: 1.5,
          color: Colors.black54,
        ),
      ),
    );
  }
}
