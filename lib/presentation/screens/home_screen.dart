import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/colorimetry_repository.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/colorimetry_result_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = UserRepository();
  final _colorimetryRepo = ColorimetryRepository();
  UserModel? _user;
  List<ColorimetryResultModel> _recentResults = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _repo.getCurrentUser();
    if (mounted) {
      setState(() => _user = user);
    }
    if (user?.id != null) {
      final results = await _colorimetryRepo.getResultsByUser(user!.id!);
      if (mounted) {
        setState(() {
          _recentResults = results.take(3).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.06))),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  Expanded(child: _BottomNavItem(
                    icon: Icons.home_rounded,
                    label: 'Inicio',
                    isActive: true,
                    onTap: () {},
                  )),
                  Expanded(child: _BottomNavItem(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'Analizar',
                    isActive: false,
                    onTap: () => Navigator.pushNamed(context, '/scanner'),
                  )),
                  Expanded(child: _BottomNavItem(
                    icon: Icons.history_rounded,
                    label: 'Historial Colorimetria',
                    isActive: false,
                    onTap: () => Navigator.pushNamed(context, '/history'),
                  )),
                  Expanded(child: _BottomNavItem(
                    icon: Icons.photo_library_outlined,
                    label: 'Historial Looks',
                    isActive: false,
                    onTap: () => Navigator.pushNamed(context, '/gallery'),
                  )),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryAccent,
                            ),
                            child: ClipOval(
                              child: Image.asset('assets/icon/app_icon.png', fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Beautyscan',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/profile').then((_) => _loadUser()),
                        child: Container(
                          width: 40,
                          height: 40,
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
                                : const Icon(Icons.person_outline_rounded, color: Colors.black54, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 48, 32, 12),
                  child: Container(
                    height: 340,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.negroCarbon.withValues(alpha: 0.10),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.asset(
                            'assets/images/chica-principal.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  AppColors.negroCarbon.withValues(alpha: 0.75),
                                  AppColors.negroCarbon.withValues(alpha: 0.15),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 24,
                          right: 24,
                          bottom: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Bienvenida',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Hola, ${_user?.name.split(' ')[0] ?? 'Usuario'}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Lo que la IA ve en ti.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -1.0,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Análisis de colorimetría con inteligencia artificial.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withValues(alpha: 0.7),
                                  letterSpacing: 0.2,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Quick actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 28, 32, 0),
                  child: Column(
                    children: [
                      _ActionCard(
                        icon: Icons.add_circle_outline_rounded,
                        title: 'Nuevo Análisis',
                        subtitle: 'Escanea y descubre tu colorimetría',
                        onTap: () => Navigator.pushNamed(context, '/scanner'),
                      ),
                      const SizedBox(height: 12),
                      _ActionCard(
                        icon: Icons.folder_outlined,
                        title: 'Historial Colorimetria',
                        subtitle: 'Historial completo de análisis de colorimetria con IA',
                        onTap: () => Navigator.pushNamed(context, '/history'),
                      ),
                      const SizedBox(height: 12),
                      _ActionCard(
                        icon: Icons.auto_awesome_mosaic_outlined,
                        title: 'Historial Looks Generados',
                        subtitle: 'Tus peinados y collages generados con IA',
                        onTap: () => Navigator.pushNamed(context, '/gallery'),
                      ),

                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 44, 32, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppColors.negroCarbon.withValues(alpha: 0.3),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Reciente',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    _recentResults.isEmpty
                      ? [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text(
                                'Sin análisis recientes',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10,
                                  color: Colors.black38,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ]
                      : _recentResults.asMap().entries.expand((entry) {
                          final i = entry.key;
                          final r = entry.value;
                          return [
                            if (i > 0) const SizedBox(height: 12),
                            _RecentAnalysisCard(
                              title: r.clientName,
                              subtitle: r.season,
                              date: _formatDate(r.createdAt),
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/analysis_results',
                                arguments: r.id,
                              ),
                            ),
                          ];
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      return '${dt.day} ${_getMonth(dt.month)}'.toUpperCase();
    } catch (_) {
      return '';
    }
  }

  String _getMonth(int m) {
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return months[m - 1];
  }
}

class _RecentAnalysisCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String date;
  final VoidCallback onTap;

  const _RecentAnalysisCard({
    required this.title,
    this.subtitle,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.negroCarbon.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Icon(Icons.palette_outlined, color: Colors.black54, size: 20),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.black54,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(Icons.chevron_right_rounded, color: Colors.black.withValues(alpha: 0.2), size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.negroCarbon.withValues(alpha: 0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.black87 : Colors.black38,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? Colors.black87 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.negroCarbon.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 22, color: Colors.black54),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: Colors.black45,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.black.withValues(alpha: 0.2), size: 20),
          ],
        ),
      ),
    );
  }
}
