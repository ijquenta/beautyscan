import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../data/repositories/colorimetry_repository.dart';
import '../../data/repositories/user_repository.dart';
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

      final items = colorimetryData.map((c) {
        Color baseColor = Colors.black87;
        if (c.recommendedColors.isNotEmpty) {
          baseColor = _hexToColor(c.recommendedColors.first);
        }
        return _HistoryItem(
          id: c.id!,
          clientName: c.clientName,
          subtitle: c.season,
          photoPath: c.photoPath,
          color: baseColor,
          createdAt: c.createdAt,
        );
      }).toList();

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

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
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
    Navigator.pushNamed(context, '/analysis_results', arguments: item.id);
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
                      'Historial Colorimetría',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black87, letterSpacing: -1.0, height: 1.0),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      cursorColor: Colors.black87,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Buscar cliente o temporada...',
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
                          return Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  title: const Text('Eliminar peinado', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600)),
                                  content: const Text('¿Seguro que quieres eliminar este peinado del historial?', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black54)),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar', style: TextStyle(fontFamily: 'Poppins', fontSize: 12))),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.redAccent))),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await _colorimetryRepo.deleteResult(item.id);
                                _loadData();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppColors.negroCarbon,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      content: const Text('Peinado eliminado', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                                    ),
                                  );
                                }
                              }
                              return false;
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
                            ),
                            child: _HistoryCard(item: item, formatDate: _formatDate, formatTime: _formatTime, onTap: () => _openItem(item)),
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

enum _ItemType { colorimetry }

class _HistoryItem {
  final int id;
  final String clientName;
  final String subtitle;
  final String photoPath;
  final Color color;
  final String createdAt;

  const _HistoryItem({
    required this.id,
    required this.clientName,
    required this.subtitle,
    required this.photoPath,
    required this.color,
    required this.createdAt,
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

  Widget _imageWithFallback(_HistoryItem item) {
    final hasPhoto = item.photoPath.isNotEmpty && File(item.photoPath).existsSync();
    if (hasPhoto) {
      return Image.file(
        File(item.photoPath),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _imagePlaceholder(item),
      );
    }
    return _imagePlaceholder(item);
  }

  Widget _imagePlaceholder(_HistoryItem item) {
    return Container(
      color: item.color.withValues(alpha: 0.12),
      child: Center(
        child: Container(
          width: 20, height: 20,
          decoration: BoxDecoration(color: item.color, borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

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
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 80,
                child: _imageWithFallback(item),
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
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 10, color: Colors.black.withValues(alpha: 0.25)),
                        const SizedBox(width: 4),
                        Text(
                          formatDate(item.createdAt),
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 9, color: Colors.black.withValues(alpha: 0.3)),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            'Colorimetría',
                            style: TextStyle(
                              fontFamily: 'Poppins', fontSize: 8, letterSpacing: 0.5,
                              color: Colors.black45,
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
      ),
    );
  }
}
