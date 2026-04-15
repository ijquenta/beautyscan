import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants.dart';
import '../../core/session_manager.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/models/user_model.dart';
import '../components/atoms/beauty_background.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _repo = UserRepository();
  UserModel? _user;
  int _colorimetryCount = 0;
  int _hairstyleCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    final user = await _repo.getCurrentUser();
    if (user != null) {
      final colorCount = await _repo.getColorimetryCount(user.id!);
      final hairCount = await _repo.getHairstyleCount(user.id!);
      if (mounted) {
        setState(() {
          _user = user;
          _colorimetryCount = colorCount;
          _hairstyleCount = hairCount;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickPhoto() async {
    if (_user == null) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 600,
    );
    if (picked == null || !mounted) return;

    final newPath = await _repo.updatePhoto(_user!.id!, picked.path);
    if (newPath != null && mounted) {
      setState(() => _user = _user!.copyWith(profilePhoto: newPath));
      _showSnack('Foto de perfil actualizada');
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500),
        ),
        backgroundColor: isError ? const Color(0xFFBF4040) : AppColors.primaryAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      ),
    );
  }

  String get _initials {
    if (_user == null || _user!.name.isEmpty) return 'U';
    final parts = _user!.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return _user!.name[0].toUpperCase();
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
            'Mi perfil',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/settings')
                    .then((_) => _loadUser()),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlassmorphism,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white60, width: 1),
                  ),
                  child: const Center(
                    child: Text(
                      'CFG',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryAccent),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: Column(
                    children: [
                      // Avatar + nombre
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 32, horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.whiteGlassmorphism,
                          borderRadius: AppConstants.largeCardRadius,
                          border: Border.all(color: Colors.white60, width: 1),
                          boxShadow: const [
                            BoxShadow(color: AppColors.shadowGlow, blurRadius: 20),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Avatar con boton de edicion
                            GestureDetector(
                              onTap: _pickPhoto,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFDE8F0),
                                          Color(0xFFE8E0F5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      border: Border.all(
                                        color: AppColors.primaryAccent
                                            .withValues(alpha: 0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: _user?.profilePhoto != null &&
                                              File(_user!.profilePhoto!)
                                                  .existsSync()
                                          ? Image.file(
                                              File(_user!.profilePhoto!),
                                              fit: BoxFit.cover,
                                            )
                                          : Center(
                                              child: Text(
                                                _initials,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall
                                                    ?.copyWith(
                                                      color:
                                                          AppColors.primaryAccent,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'CAM',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 7,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _user?.name ?? 'Usuario',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _user?.email ?? '',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Colors.black45,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Stats reales
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _StatItem(
                                  value: (_colorimetryCount + _hairstyleCount)
                                      .toString(),
                                  label: 'Análisis',
                                ),
                                Container(
                                    width: 1,
                                    height: 36,
                                    color: Colors.black12),
                                _StatItem(
                                  value: _hairstyleCount.toString(),
                                  label: 'Peinados',
                                ),
                                Container(
                                    width: 1,
                                    height: 36,
                                    color: Colors.black12),
                                _StatItem(
                                  value: _colorimetryCount.toString(),
                                  label: 'Colores',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      _SectionHeader(label: 'Mi cuenta'),
                      const SizedBox(height: 12),
                      _MenuItem(
                        label: 'Mis análisis',
                        subtitle: 'Ver historial completo',
                        color: AppColors.primaryAccent,
                        onTap: () => Navigator.pushNamed(context, '/history'),
                      ),
                      const SizedBox(height: 10),
                      _MenuItem(
                        label: 'Mi galería',
                        subtitle: 'Fotos y resultados guardados',
                        color: const Color(0xFF7C5CBF),
                        onTap: () => Navigator.pushNamed(context, '/gallery'),
                      ),

                      const SizedBox(height: 20),

                      _SectionHeader(label: 'Configuración'),
                      const SizedBox(height: 12),
                      _MenuItem(
                        label: 'Editar perfil',
                        subtitle: 'Nombre, foto y contraseña',
                        color: const Color(0xFF3A6FD8),
                        onTap: () => Navigator.pushNamed(context, '/settings')
                            .then((_) => _loadUser()),
                      ),
                      const SizedBox(height: 10),
                      _MenuItem(
                        label: 'Ayuda y soporte',
                        subtitle: 'Centro de ayuda y contacto',
                        color: const Color(0xFF2E9E6E),
                        onTap: () => Navigator.pushNamed(context, '/feedback'),
                      ),

                      const SizedBox(height: 20),

                      // Cerrar sesion
                      GestureDetector(
                        onTap: () async {
                          await SessionManager.clearSession();
                          if (mounted) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEEEE),
                            borderRadius: AppConstants.defaultCardRadius,
                            border: Border.all(
                                color: const Color(0xFFFFCCCC), width: 1),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Cerrar sesión',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xFFBF4040),
                                ),
                              ),
                            ],
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

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.primaryAccent,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteGlassmorphism,
          borderRadius: AppConstants.defaultCardRadius,
          border: Border.all(color: Colors.white60, width: 1),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowGlow, blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: color),
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
                  const SizedBox(height: 2),
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
            Icon(Icons.chevron_right_rounded,
                color: color.withValues(alpha: 0.6), size: 22),
          ],
        ),
      ),
    );
  }
}
