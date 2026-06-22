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
      _showSnack('Retrato actualizado');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, letterSpacing: 2.0, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: AppColors.negroCarbon,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
            child: const Padding(
              padding: EdgeInsets.only(left: 24, top: 20),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_rounded, size: 18, color: Colors.black54),
                    SizedBox(width: 6),
                    Text('Volver', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54)),
                  ],
                ),
              ),
            ),
          ),
          leadingWidth: 100,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.black87, strokeWidth: 1.5),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(32, 40, 32, 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Area
                      Center(
                        child: GestureDetector(
                          onTap: _pickPhoto,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black12, width: 1),
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            child: ClipOval(
                              child: _user?.profilePhoto != null && File(_user!.profilePhoto!).existsSync()
                                  ? Image.file(
                                      File(_user!.profilePhoto!),
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Text(
                                        _initials,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 48,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: GestureDetector(
                          onTap: _pickPhoto,
                          child: const Text(
                            'Actualizar',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),

                      // User Info
                      const Text(
                        'Perfil',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                          color: Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _user?.name ?? 'Usuario',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        _user?.email ?? '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.black54,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatItem(value: '${_colorimetryCount + _hairstyleCount}', label: 'Análisis'),
                          _StatItem(value: '$_colorimetryCount', label: 'Colores'),
                          _StatItem(value: '$_hairstyleCount', label: 'Peinados'),
                        ],
                      ),

                      const SizedBox(height: 60),
                      Container(width: double.infinity, height: 1, color: Colors.black12),

                      // Minimialist Menu Options
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/settings').then((_) => _loadUser()),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: const Text(
                            'Configuración',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await SessionManager.clearSession();
                          if (mounted) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: const Text(
                            'Cerrar sesión',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              color: Colors.black54,
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

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 9,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}
