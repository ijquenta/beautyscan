import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = UserRepository();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _repo.getCurrentUser();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeautyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black12, width: 1)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BottomNavButton(
                    label: 'PRINCIPAL',
                    isActive: true,
                    onTap: () {},
                  ),
                  _BottomNavButton(
                    label: 'ANALIZAR',
                    isActive: false,
                    onTap: () => Navigator.pushNamed(context, '/scanner'),
                  ),
                  _BottomNavButton(
                    label: 'HISTORIAL',
                    isActive: false,
                    onTap: () => Navigator.pushNamed(context, '/history'),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
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
                          const SizedBox(width: 8),
                          const Text(
                            'BEAUTYSCAN',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              letterSpacing: 3.0,
                              fontWeight: FontWeight.w700,
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
                  padding: const EdgeInsets.fromLTRB(32, 60, 32, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, ${_user?.name?.split(' ')[0] ?? 'Usuario'}',
                        style: const TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 36,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Descubre tu\nesencia.',
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: -1.0,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 40),

                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/scanner'),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Nuevo Análisis',
                                style: TextStyle(
                                  fontFamily: 'PlayfairDisplay',
                                  fontSize: 24,
                                  color: Colors.black87,
                                ),
                              ),
                              Icon(Icons.arrow_forward_rounded, color: Colors.black54, size: 20),
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/gallery'),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Galería',
                                style: TextStyle(
                                  fontFamily: 'PlayfairDisplay',
                                  fontSize: 24,
                                  color: Colors.black54,
                                ),
                              ),
                              Icon(Icons.arrow_forward_rounded, color: Colors.black38, size: 20),
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/history'),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'El Archivo',
                                style: TextStyle(
                                  fontFamily: 'PlayfairDisplay',
                                  fontSize: 24,
                                  color: Colors.black54,
                                ),
                              ),
                              Icon(Icons.arrow_forward_rounded, color: Colors.black38, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Últimos análisis
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 10),
                  child: const Text(
                    'RECIENTE',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _EditorialLogCard(
                      title: 'Primavera Cálida',
                      category: 'Colorimetría',
                      date: 'Hace 2 días',
                      onTap: () => Navigator.pushNamed(context, '/analysis_results'),
                    ),
                    const SizedBox(height: 16),
                    _EditorialLogCard(
                      title: 'Bob Texturizado',
                      category: 'Peinado',
                      date: 'Hace 5 días',
                      onTap: () => Navigator.pushNamed(context, '/hairstyle_display'),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditorialLogCard extends StatelessWidget {
  final String title;
  final String category;
  final String date;
  final VoidCallback onTap;

  const _EditorialLogCard({
    required this.title,
    required this.category,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent, // Zonas activas
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                fontWeight: FontWeight.w400,
                color: Colors.black38,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9,
                      color: Colors.black45,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            letterSpacing: 2.0,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            color: isActive ? Colors.black87 : Colors.black38,
          ),
        ),
      ),
    );
  }
}
