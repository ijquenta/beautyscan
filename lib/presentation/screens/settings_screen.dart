import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/session_manager.dart';
import '../components/atoms/beauty_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _analysisReminders = false;
  bool _weeklyTips = true;

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
            'Configuración',
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
                // Sección Cuenta
                _SettingsSectionTitle(label: 'Cuenta'),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlassmorphism,
                    borderRadius: AppConstants.defaultCardRadius,
                    border: Border.all(color: Colors.white60, width: 1),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadowGlow, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SettingsTile(
                        label: 'Editar perfil',
                        subtitle: 'Nombre y foto de perfil',
                        color: AppColors.primaryAccent,
                        showArrow: true,
                        onTap: () {},
                        isFirst: true,
                        isLast: false,
                      ),
                      _Divider(),
                      _SettingsTile(
                        label: 'Cambiar contraseña',
                        subtitle: 'Actualiza tu seguridad',
                        color: const Color(0xFF3A6FD8),
                        showArrow: true,
                        onTap: () {},
                        isFirst: false,
                        isLast: false,
                      ),
                      _Divider(),
                      _SettingsTile(
                        label: 'Correo electrónico',
                        subtitle: 'usuario@correo.com',
                        color: const Color(0xFF7C5CBF),
                        showArrow: false,
                        onTap: () {},
                        isFirst: false,
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Sección Notificaciones
                _SettingsSectionTitle(label: 'Notificaciones'),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlassmorphism,
                    borderRadius: AppConstants.defaultCardRadius,
                    border: Border.all(color: Colors.white60, width: 1),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadowGlow, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SettingsToggleTile(
                        label: 'Notificaciones',
                        subtitle: 'Activar todas las alertas',
                        color: AppColors.primaryAccent,
                        value: _notificationsEnabled,
                        onChanged: (v) => setState(() => _notificationsEnabled = v),
                        isFirst: true,
                        isLast: false,
                      ),
                      _Divider(),
                      _SettingsToggleTile(
                        label: 'Recordatorios de análisis',
                        subtitle: 'Te avisamos para nuevos escaneos',
                        color: const Color(0xFF3A6FD8),
                        value: _analysisReminders,
                        onChanged: (v) => setState(() => _analysisReminders = v),
                        isFirst: false,
                        isLast: false,
                      ),
                      _Divider(),
                      _SettingsToggleTile(
                        label: 'Tips semanales',
                        subtitle: 'Consejos de moda y belleza',
                        color: const Color(0xFF2E9E6E),
                        value: _weeklyTips,
                        onChanged: (v) => setState(() => _weeklyTips = v),
                        isFirst: false,
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Sección Aplicación
                _SettingsSectionTitle(label: 'Aplicación'),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlassmorphism,
                    borderRadius: AppConstants.defaultCardRadius,
                    border: Border.all(color: Colors.white60, width: 1),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadowGlow, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SettingsTile(
                        label: 'Idioma',
                        subtitle: 'Español',
                        color: const Color(0xFFD4721A),
                        showArrow: true,
                        onTap: () {},
                        isFirst: true,
                        isLast: false,
                      ),
                      _Divider(),
                      _SettingsTile(
                        label: 'Versión',
                        subtitle: '1.0.0',
                        color: Colors.black38,
                        showArrow: false,
                        onTap: () {},
                        isFirst: false,
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Sección Soporte
                _SettingsSectionTitle(label: 'Soporte'),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlassmorphism,
                    borderRadius: AppConstants.defaultCardRadius,
                    border: Border.all(color: Colors.white60, width: 1),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadowGlow, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SettingsTile(
                        label: 'Ayuda y feedback',
                        subtitle: 'Cuéntanos tu experiencia',
                        color: AppColors.primaryAccent,
                        showArrow: true,
                        onTap: () => Navigator.pushNamed(context, '/feedback'),
                        isFirst: true,
                        isLast: false,
                      ),
                      _Divider(),
                      _SettingsTile(
                        label: 'Política de privacidad',
                        subtitle: 'Cómo usamos tus datos',
                        color: const Color(0xFF3A6FD8),
                        showArrow: true,
                        onTap: () {},
                        isFirst: false,
                        isLast: false,
                      ),
                      _Divider(),
                      _SettingsTile(
                        label: 'Términos y condiciones',
                        subtitle: 'Acuerdo de uso',
                        color: const Color(0xFF7C5CBF),
                        showArrow: true,
                        onTap: () {},
                        isFirst: false,
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Cerrar sesion
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
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEEE),
                      borderRadius: AppConstants.defaultCardRadius,
                      border: Border.all(color: const Color(0xFFFFCCCC), width: 1),
                    ),
                    child: const Center(
                      child: Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xFFBF4040),
                        ),
                      ),
                    ),
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

class _SettingsSectionTitle extends StatelessWidget {
  final String label;
  const _SettingsSectionTitle({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 74),
      height: 1,
      color: Colors.black.withValues(alpha: 0.05),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final bool showArrow;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _SettingsTile({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.showArrow,
    required this.onTap,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              Icon(Icons.chevron_right_rounded,
                  color: color.withValues(alpha: 0.5), size: 20),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isFirst;
  final bool isLast;

  const _SettingsToggleTile({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.value,
    required this.onChanged,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: color,
            activeTrackColor: color.withValues(alpha: 0.25),
            inactiveThumbColor: Colors.black26,
            inactiveTrackColor: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
    );
  }
}
