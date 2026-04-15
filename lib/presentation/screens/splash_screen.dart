import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/session_manager.dart';
import '../../data/repositories/user_repository.dart';
import '../components/atoms/beauty_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      final hasSession = await SessionManager.isLoggedIn();
      var loggedIn = false;
      if (hasSession) {
        final currentUser = await _userRepository.getCurrentUser();
        if (currentUser != null) {
          loggedIn = true;
        } else {
          await SessionManager.clearSession();
        }
      }
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          // loggedIn ? '/home' : '/onboarding',
          '/onboarding', // Forzado para que puedas visualizarlo ahora mismo
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icon/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'BEAUTYSCAN',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tu asesor de imagen con IA',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),

                const Spacer(flex: 4),

                SizedBox(
                  width: 140,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 3),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return Stack(
                        children: [
                          Container(
                            height: 1.5,
                            width: double.infinity,
                            color: Colors.black12,
                          ),
                          Container(
                            height: 1.5,
                            width: 140 * value,
                            color: Colors.black87,
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
