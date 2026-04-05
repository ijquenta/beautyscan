import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class BeforeAfterSlider extends StatefulWidget {
  final ImageProvider beforeImage;
  final ImageProvider afterImage;
  
  const BeforeAfterSlider({
    Key? key, 
    required this.beforeImage, 
    required this.afterImage,
  }) : super(key: key);

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        return ClipRRect(
          borderRadius: AppConstants.largeCardRadius,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _sliderValue += details.delta.dx / width;
                _sliderValue = _sliderValue.clamp(0.0, 1.0);
              });
            },
            child: Stack(
              children: [
                // Imagen de fondo (Después / Resultado IA)
                Positioned.fill(
                  child: Image(
                    image: widget.afterImage,
                    fit: BoxFit.cover,
                  ),
                ),
                
                // Imagen frontal (Antes / Original) recortada (Wipe)
                Positioned.fill(
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: _sliderValue,
                      child: Image(
                        image: widget.beforeImage,
                        fit: BoxFit.cover,
                        // Forzamos el ancho para obligar al Align a recortar visualmente sin "aplastar"
                        width: width,
                        height: height,
                      ),
                    ),
                  ),
                ),
                
                // Línea deslizadora y botón central
                Positioned(
                  left: width * _sliderValue - 16,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 32,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Expanded(child: Container(width: 3, color: Colors.white)),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 4)
                            ],
                          ),
                          child: const Icon(
                            Icons.compare_arrows_rounded, 
                            size: 20, 
                            color: AppColors.primaryAccent,
                          ),
                        ),
                        Expanded(child: Container(width: 3, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                
                // Etiquetas de estado
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: _buildLabel('Antes', _sliderValue > 0.2),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _buildLabel('Después', _sliderValue < 0.8),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text, bool isVisible) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isVisible ? 1.0 : 0.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 12
          ),
        ),
      ),
    );
  }
}
