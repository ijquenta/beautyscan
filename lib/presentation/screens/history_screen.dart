import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/repositories/colorimetry_repository.dart';
import '../../data/repositories/hairstyle_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/models/hairstyle_model.dart';
import '../components/atoms/beauty_background.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = true;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  List<_HistoryItem> _allItems = [];

  final ColorimetryRepository _colorimetryRepo = ColorimetryRepository();
  final HairstyleRepository _hairstyleRepo = HairstyleRepository();
  final UserRepository _userRepo = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final user = await _userRepo.getCurrentUser();
    if (user != null) {
      final colorimetryData = await _colorimetryRepo.getResultsByUser(user.id!);
      final hairstyleData = await _hairstyleRepo.getResultsByUser(user.id!);

      final items = <_HistoryItem>[];

      for (final c in colorimetryData) {
        items.add(_HistoryItem(
          id: c.id!,
          type: _ItemType.colorimetry,
          clientName: c.clientName,
          photoPath: c.photoPath,
          subtitle: '${c.recommendedColors.length} colores · ${c.undertone}',
          createdAt: c.createdAt,
          route: '/analysis_results',
        ));
      }

      for (final h in hairstyleData) {
        items.add(_HistoryItem(
          id: h.id!,
          type: _ItemType.hairstyle,
          clientName: h.hairstyleName,
          photoPath: h.resultImageUrl,
          subtitle: 'Peinado generado con IA',
          createdAt: h.createdAt,
          route: '/hairstyle_display',
        ));
      }

      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (mounted) {
        setState(() {
          _allItems = items;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<_HistoryItem> get _filtered {
    if (_searchQuery.isEmpty) return _allItems;
    final query = _searchQuery.toLowerCase();
    return _allItems.where((e) =>
      e.clientName.toLowerCase().contains(query) ||
      e.subtitle.toLowerCase().contains(query)
    ).toList();
  }

  String _formatDate(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return '';
    }
  }

  String _formatTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return '';
    }
  }

  void _openItem(_HistoryItem item) {
    if (item.type == _ItemType.colorimetry) {
      Navigator.pushNamed(context, item.route, arguments: item.id);
    } else {
      final style = HairstyleModel.catalog.where(
        (s) => s.name.replaceAll('\n', ' ') == item.clientName,
      ).firstOrNull;
      Navigator.pushNamed(context, item.route, arguments: {
        'style': style,
        'photoPath': item.photoPath,
        'originalPhotoPath': item.photoPath,
        'fromHistory': true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

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
                'Volver',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 10, letterSpacing: 2.0, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ),
          leadingWidth: 100,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Historial',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87, letterSpacing: -1.0, height: 1.0),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      cursorColor: Colors.black87,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre...',
                        hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black.withValues(alpha: 0.3)),
                        prefixIcon: Icon(Icons.search_rounded, size: 18, color: Colors.black.withValues(alpha: 0.3)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.7),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.9), width: 1)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: Colors.black87, width: 1)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: _isLoading
                  ? const Center(child: Text('Cargando...', style: TextStyle(fontFamily: 'Poppins', letterSpacing: 2.0, color: Colors.black38)))
                  : filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox_rounded, size: 40, color: Colors.black.withValues(alpha: 0.15)),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty ? 'Sin resultados' : 'Aún no hay registros',
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, letterSpacing: 1.0, color: Colors.black38),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _HistoryCard(item: item, formatDate: _formatDate, formatTime: _formatTime, onTap: () => _openItem(item));
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

enum _ItemType { colorimetry, hairstyle }

class _HistoryItem {
  final int id;
  final _ItemType type;
  final String clientName;
  final String photoPath;
  final String subtitle;
  final String createdAt;
  final String route;

  const _HistoryItem({
    required this.id,
    required this.type,
    required this.clientName,
    required this.photoPath,
    required this.subtitle,
    required this.createdAt,
    required this.route,
  });
}

class _HistoryCard extends StatelessWidget {
  final _HistoryItem item;
  final String Function(String) formatDate;
  final String Function(String) formatTime;
  final VoidCallback onTap;

  const _HistoryCard({
    required this.item,
    required this.formatDate,
    required this.formatTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.file(
                  File(item.photoPath),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.black.withValues(alpha: 0.05),
                    child: Icon(Icons.image_outlined, size: 28, color: Colors.black.withValues(alpha: 0.2)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.clientName,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.black45),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 10, color: Colors.black.withValues(alpha: 0.25)),
                        const SizedBox(width: 4),
                        Text(
                          '${formatDate(item.createdAt)} · ${formatTime(item.createdAt)}',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Colors.black.withValues(alpha: 0.3)),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: item.type == _ItemType.colorimetry
                                ? Colors.black.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            item.type == _ItemType.colorimetry ? 'Colorimetría' : 'Peinado',
                            style: TextStyle(
                              fontFamily: 'Poppins', fontSize: 8, letterSpacing: 0.5,
                              color: Colors.black.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
