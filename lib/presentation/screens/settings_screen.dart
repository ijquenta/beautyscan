import 'package:flutter/material.dart';
import '../../core/session_manager.dart';
import '../components/atoms/beauty_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

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
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'PREFERENCIAS',
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
                      'Tu cuenta.',
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

              // Opciones Minimizadas
              _buildSettingAction('EDITAR PERFIL'),
              _buildSettingAction('CAMBIAR CONTRASEÑA'),
              _buildSettingAction('CORREO DE LA CUENTA', isSubtitle: true),

              const Spacer(),

              GestureDetector(
                onTap: () async {
                  await SessionManager.clearSession();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12, width: 1.5)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: const Center(
                    child: Text(
                      'CERRAR SESIÓN',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                        color: Colors.black87,
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

  Widget _buildSettingAction(String label, {bool isSubtitle = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                letterSpacing: 2.0,
                fontWeight: isSubtitle ? FontWeight.w400 : FontWeight.w700,
                color: isSubtitle ? Colors.black45 : Colors.black87,
              ),
            ),
            if (!isSubtitle)
              const Icon(Icons.chevron_right, color: Colors.black38, size: 16),
          ],
        ),
      ),
    );
  }
}
