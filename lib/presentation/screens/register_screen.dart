import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/session_manager.dart';
import '../../data/repositories/user_repository.dart';
import '../components/atoms/beauty_background.dart';
import '../components/atoms/beauty_button.dart';
import '../components/molecules/beauty_alert.dart';
import '../components/molecules/beauty_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _repo = UserRepository();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = await _repo.register(
      _nameController.text.trim(),
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
        () => _errorMessage = 'Revisa los datos. El correo podría existir.',
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Registro.',
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
                    'Un nuevo comienzo.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.black45,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  if (_errorMessage != null)
                    BeautyAlert(message: _errorMessage!),

                  BeautyTextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    hintText: 'Nombre completo',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Requerido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  BeautyTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Correo electrónico',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Requerido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  BeautyTextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    hintText: 'Contraseña',
                    suffixIcon: GestureDetector(
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
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Requerido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  BeautyTextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isPasswordVisible,
                    hintText: 'Confirmar contraseña',
                    validator: (value) {
                      if (value != _passwordController.text) return 'No coinciden';
                      return null;
                    },
                  ),

                  const SizedBox(height: 48),

                  BeautyButton(
                    text: 'REGISTRARSE',
                    isLoading: _isLoading,
                    onPressed: _onRegisterPressed,
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text(
                        'VOLVER AL INICIO',
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
