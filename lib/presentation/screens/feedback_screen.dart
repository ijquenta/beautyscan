import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _selectedRating = 0;
  int _selectedCategory = 0;
  final _commentController = TextEditingController();

  final List<String> _categories = [
    'Análisis de color',
    'Simulación de peinado',
    'Diseño de la app',
    'Otro',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '¡Gracias por tu feedback!',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppColors.primaryAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      ),
    );
    Navigator.pop(context);
  }

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
            'Tu opinión',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC2547A), Color(0xFFD4729A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppConstants.largeCardRadius,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ayúdanos a mejorar',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tu opinión nos permite ofrecerte\nuna mejor experiencia beauty',
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

                // Calificacion con estrellas
                Text(
                  '¿Cómo calificarías la app?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlassmorphism,
                    borderRadius: AppConstants.defaultCardRadius,
                    border: Border.all(color: Colors.white60, width: 1),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadowGlow, blurRadius: 12),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          final filled = i < _selectedRating;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedRating = i + 1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: filled ? 38 : 32,
                                height: filled ? 38 : 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: filled
                                      ? AppColors.primaryAccent
                                      : AppColors.primaryAccent.withValues(alpha: 0.1),
                                  boxShadow: filled
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primaryAccent.withValues(alpha: 0.35),
                                            blurRadius: 10,
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    '★',
                                    style: TextStyle(
                                      color: filled ? Colors.white : AppColors.primaryAccent.withValues(alpha: 0.4),
                                      fontSize: filled ? 18 : 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _selectedRating == 0
                            ? 'Toca para calificar'
                            : _selectedRating == 5
                                ? '¡Excelente!'
                                : _selectedRating >= 4
                                    ? 'Muy buena'
                                    : _selectedRating >= 3
                                        ? 'Buena'
                                        : _selectedRating >= 2
                                            ? 'Regular'
                                            : 'Mejorable',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: _selectedRating == 0 ? Colors.black38 : AppColors.primaryAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Categoría
                Text(
                  '¿Sobre qué es tu comentario?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _categories.asMap().entries.map((entry) {
                    final i = entry.key;
                    final label = entry.value;
                    final isActive = i == _selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryAccent
                              : AppColors.whiteGlassmorphism,
                          borderRadius: AppConstants.pillBorderRadius,
                          border: Border.all(
                            color: isActive ? AppColors.primaryAccent : Colors.white60,
                            width: 1,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryAccent.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Comentario
                Text(
                  'Cuéntanos más',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Escribe aquí tu sugerencia, error o comentario...',
                    hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
                    filled: true,
                    fillColor: AppColors.whiteGlassmorphism,
                    border: OutlineInputBorder(
                      borderRadius: AppConstants.defaultCardRadius,
                      borderSide: const BorderSide(color: Colors.white60),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppConstants.defaultCardRadius,
                      borderSide: const BorderSide(color: Colors.white60),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppConstants.defaultCardRadius,
                      borderSide: const BorderSide(
                        color: AppColors.primaryAccent,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(18),
                  ),
                ),

                const SizedBox(height: 32),

                // Botón enviar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    child: const Text('Enviar comentario'),
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
