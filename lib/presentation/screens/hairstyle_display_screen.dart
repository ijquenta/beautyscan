import 'package:flutter/material.dart';
import '../components/atoms/beauty_background.dart';
import '../components/organisms/before_after_slider.dart';

class HairstyleDisplayScreen extends StatelessWidget {
  const HairstyleDisplayScreen({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'EL RESULTADO',
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
                      'Simulación.',
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: -1.0,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              // Image slider without shadows or borders (pure flat display)
              Expanded(
                child: Container(
                  color: Colors.black, // Dark background frame for the photography
                  margin: const EdgeInsets.symmetric(horizontal: 0),
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

              // Feedback interaction minimal line
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12, width: 1.5)),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'AJUSTAR (EJ: MÁS OSCURO)',
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              letterSpacing: 2.0,
                              color: Colors.black38,
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            letterSpacing: 2.0,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
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

              const SizedBox(height: 32),

              // Bottom Actions
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/hairstyle_detail'),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 24),
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
                onTap: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
                child: Container(
                  width: double.infinity,
                  color: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 24),
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
