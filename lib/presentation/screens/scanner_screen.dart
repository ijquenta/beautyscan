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
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: const Text(
            'DATOS DEL ANÁLISIS',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              letterSpacing: 3.0,
              fontWeight: FontWeight.bold,
              color: Colors.black38,
            ),
          ),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            cursorColor: Colors.black87,
            style: const TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 24,
              color: Colors.black87,
            ),
            decoration: const InputDecoration(
              hintText: 'Nombre de la clienta',
              hintStyle: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 24,
                color: Colors.black26,
              ),
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text(
                'CANCELAR',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  letterSpacing: 2.0,
                  color: Colors.black54,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text.trim();
                Navigator.pop(context, text.isNotEmpty ? text : 'Cliente Anónimo');
              },
              child: const Text(
                'CONTINUAR',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
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
          // BACKGROUND IMAGE
          Image.asset(
            'assets/images/foto-chica.png',
            fit: BoxFit.cover,
          ),
          
          // Subtle dark overlay to ensure UI elements are visible
          Container(
            color: Colors.black.withValues(alpha: 0.3),
          ),

          // Subtle overlays (gradients)
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

          // Header
          Positioned(
            top: 60,
            left: 32,
            right: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'CERRAR',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const Text(
                  'ROSTRO EN LUZ NATURAL',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Framing brackets
          Center(
            child: SizedBox(
              width: 250,
              height: 350,
              child: Stack(
                children: const [
                  _CornerBracket(alignment: Alignment.topLeft),
                  _CornerBracket(alignment: Alignment.topRight),
                  _CornerBracket(alignment: Alignment.bottomLeft),
                  _CornerBracket(alignment: Alignment.bottomRight),
                ],
              ),
            ),
          ),

          // Controls
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
                  child: const Text(
                    'GALERÍA',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.camera),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Container(
                        width: 58,
                        height: 58,
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
                  child: const Text(
                    'HISTORIAL',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.0,
                    ),
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
    return Align(
      alignment: alignment,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0 ? const BorderSide(color: Colors.white54, width: 1) : BorderSide.none,
            bottom: alignment.y > 0 ? const BorderSide(color: Colors.white54, width: 1) : BorderSide.none,
            left: alignment.x < 0 ? const BorderSide(color: Colors.white54, width: 1) : BorderSide.none,
            right: alignment.x > 0 ? const BorderSide(color: Colors.white54, width: 1) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
