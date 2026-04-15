import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/session_manager.dart';
import '../../data/repositories/user_repository.dart';
import '../components/atoms/beauty_background.dart';
import '../components/atoms/beauty_button.dart';
import '../components/molecules/beauty_alert.dart';
import '../components/molecules/beauty_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repo = UserRepository();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = await _repo.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user != null) {
      await SessionManager.saveSession(user.id!);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      setState(
        () => _errorMessage = 'Revisa tus credenciales.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Entrar.',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 48,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Es un placer verte de nuevo.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.black45,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 64),

                  if (_errorMessage != null)
                    BeautyAlert(message: _errorMessage!),

                  BeautyTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Correo electrónico',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Ingresa tu correo';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  BeautyTextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    hintText: 'Contraseña',
                    suffixIcon: _passwordController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                _isPasswordVisible ? 'CERRAR' : 'VER',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          )
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
                      return null;
                    },
                  ),

                  const SizedBox(height: 64),

                  BeautyButton(
                    text: 'Continuar',
                    isLoading: _isLoading,
                    onPressed: _onLoginPressed,
                  ),

                  const SizedBox(height: 48),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                      child: const Text(
                        'CREAR CUENTA',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
