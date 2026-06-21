import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../data/repositories/colorimetry_repository.dart';
import '../../data/repositories/hairstyle_repository.dart';
import '../../domain/models/hairstyle_model.dart';
import '../../data/repositories/user_repository.dart';
import '../components/atoms/beauty_background.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int _selectedFilter = 0;
  bool _isLoading = true;
  List<_GalleryItem> _items = [];

  final ColorimetryRepository _colorimetryRepo = ColorimetryRepository();
  final HairstyleRepository _hairstyleRepo = HairstyleRepository();
  final UserRepository _userRepo = UserRepository();
  final List<String> _filters = ['Todas', 'Colorimetría', 'Peinados'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _userRepo.getCurrentUser();
    if (user != null) {
      final colorimetryData = await _colorimetryRepo.getResultsByUser(user.id!);
      final hairstyleData = await _hairstyleRepo.getResultsByUser(user.id!);

      final items = <_GalleryItem>[
        ...colorimetryData.map((c) {
          Color baseColor = Colors.black87;
          if (c.recommendedColors.isNotEmpty) {
            baseColor = _hexToColor(c.recommendedColors.first);
          }
          return _GalleryItem(
            id: c.id!,
            type: 'Colorimetría',
            clientName: c.clientName,
            subtitle: c.season,
            date: _formatDate(c.createdAt),
            color: baseColor,
            route: '/analysis_results',
          );
        }),
        ...hairstyleData.map((h) {
          return _GalleryItem(
            id: h.id!,
            type: 'Peinado',
            clientName: h.personName.isNotEmpty ? h.personName : h.hairstyleName,
            subtitle: h.personName.isNotEmpty ? h.hairstyleName : '',
            date: _formatDate(h.createdAt),
            color: Colors.black87,
            route: '/hairstyle_display',
            routeArgs: {
              'style': HairstyleModel(
                id: h.hairstyleName,
                name: h.hairstyleName,
                description: h.hairstyleName,
                styleType: '',
                maintenanceLevel: 'Moderado',
                accentColor: Colors.black87,
                stylistSteps: [],
                products: [],
                imagePath: '',
              ),
              'photoPath': h.resultImageUrl,
              'originalPhotoPath': h.originalPhotoPath,
            },
          );
        }),
      ];

      if (mounted) {
        setState(() {
          _items = items;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  String _formatDate(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      return '${dt.day} ${_getMonth(dt.month)}';
    } catch (_) {
      return '';
    }
  }

  String _getMonth(int m) {
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return months[m - 1];
  }

  List<_GalleryItem> get _filtered {
    if (_selectedFilter == 0) return _items;
    final filterType = _selectedFilter == 1 ? 'Colorimetría' : 'Peinado';
    return _items.where((i) => i.type == filterType).toList();
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
              padding: EdgeInsets.only(left: 32, top: 20),
              child: Text('Volver', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54)),
            ),
          ),
          leadingWidth: 100,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 4, 32, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('El Archivo', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600, color: Colors.black45)),
                    SizedBox(height: 12),
                    Text('Galería.', style: TextStyle(fontFamily: 'Poppins', fontSize: 40, fontWeight: FontWeight.w700, color: AppColors.negroCarbon, letterSpacing: -1.0, height: 1.0)),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: _filters.asMap().entries.map((entry) {
                    final i = entry.key;
                    final label = entry.value;
                    final isActive = i == _selectedFilter;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = i),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.negroCarbon : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive ? Colors.transparent : Colors.black.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                            color: isActive ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 28),

              Expanded(
                child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.negroCarbon))
                  : _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open_outlined, size: 40, color: Colors.black.withValues(alpha: 0.1)),
                            const SizedBox(height: 12),
                            const Text('Galería vacía', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black38)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          final item = _filtered[index];
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(context, item.route, arguments: item.routeArgs ?? item.id),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: item.color.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: item.color,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.clientName,
                                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.subtitle,
                                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black54),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.negroCarbon.withValues(alpha: 0.05),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                item.type,
                                                style: const TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: FontWeight.w600, color: Colors.black45),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              item.date,
                                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Colors.black38),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right_rounded, size: 20, color: Colors.black.withValues(alpha: 0.15)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryItem {
  final int id;
  final String type;
  final String clientName;
  final String subtitle;
  final String date;
  final Color color;
  final String route;
  final Map<String, dynamic>? routeArgs;

  const _GalleryItem({
    required this.id,
    required this.type,
    required this.clientName,
    required this.subtitle,
    required this.date,
    required this.color,
    required this.route,
    this.routeArgs,
  });
}
