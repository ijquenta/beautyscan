import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(source: source);
      final XFile? finalPhoto = photo;

      if (finalPhoto != null) {
        if (!mounted) return;

        final clientName = await _askClientName(context);
        if (clientName != null && mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/analysis',
            arguments: {
              'path': finalPhoto.path,
              'clientName': clientName,
            },
          );
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<String?> _askClientName(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFBFBFB),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.person_outline_rounded, color: Colors.black54, size: 22),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nombre de la clienta',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            cursorColor: Colors.black87,
            autofocus: true,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Ej: Ana García',
              hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black26),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.04),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.black87, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black45),
              ),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text.trim();
                Navigator.pop(context, text.isNotEmpty ? text : 'Cliente Anónimo');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Comenzar',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/foto-chica.png',
            fit: BoxFit.cover,
          ),

          Container(
            color: Colors.black.withValues(alpha: 0.3),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 140,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 60,
            left: 32,
            right: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.8), size: 20),
                      const SizedBox(width: 6),
                      const Text(
                        'Cerrar',
                        style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.wb_sunny_rounded, color: Colors.white.withValues(alpha: 0.5), size: 12),
                    const SizedBox(width: 6),
                    const Text(
                      'Rostro en luz natural',
                      style: TextStyle(fontFamily: 'Poppins', color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Center(
            child: Container(
              width: 260,
              height: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -1,
                    left: -1,
                    child: _CornerBracket(alignment: const Alignment(-1, -1)),
                  ),
                  Positioned(
                    top: -1,
                    right: -1,
                    child: _CornerBracket(alignment: const Alignment(1, -1)),
                  ),
                  Positioned(
                    bottom: -1,
                    left: -1,
                    child: _CornerBracket(alignment: const Alignment(-1, 1)),
                  ),
                  Positioned(
                    bottom: -1,
                    right: -1,
                    child: _CornerBracket(alignment: const Alignment(1, 1)),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 20),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Galería',
                        style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 11, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.camera),
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Container(
                        width: 62,
                        height: 62,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/gallery'),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.history_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Historial',
                        style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 11, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final Alignment alignment;
  const _CornerBracket({required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: alignment.y < 0 ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none,
          bottom: alignment.y > 0 ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none,
          left: alignment.x < 0 ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none,
          right: alignment.x > 0 ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none,
        ),
      ),
    );
  }
}
