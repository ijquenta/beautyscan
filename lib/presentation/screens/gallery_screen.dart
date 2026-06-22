import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../data/repositories/hairstyle_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/models/hairstyle_model.dart';
import '../components/atoms/beauty_background.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool _isLoading = true;
  List<_GalleryItem> _items = [];

  final HairstyleRepository _hairstyleRepo = HairstyleRepository();
  final UserRepository _userRepo = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _userRepo.getCurrentUser();
    if (user != null) {
      final hairstyleData = await _hairstyleRepo.getResultsByUser(user.id!);

      final items = hairstyleData.map((h) {
        return _GalleryItem(
          id: h.id!,
          clientName: h.personName.isNotEmpty ? h.personName : h.hairstyleName,
          subtitle: h.personName.isNotEmpty ? h.hairstyleName : '',
          date: _formatDate(h.createdAt),
          photoPath: h.resultImageUrl,
        );
      }).toList();

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

  Widget _buildCard(_GalleryItem item) {
    final hasPhoto = item.photoPath.isNotEmpty && File(item.photoPath).existsSync();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/hairstyle_display', arguments: {
          'style': HairstyleModel(
            id: item.clientName,
            name: item.clientName,
            description: item.clientName,
            styleType: '',
            maintenanceLevel: 'Moderado',
            accentColor: AppColors.negroCarbon,
            stylistSteps: [],
            products: [],
            imagePath: '',
          ),
          'photoPath': item.photoPath,
          'originalPhotoPath': item.photoPath,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                child: hasPhoto
                    ? Image.file(File(item.photoPath), fit: BoxFit.cover, errorBuilder: (_, __, ___) => _imagePlaceholder())
                    : _imagePlaceholder(),
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
                      if (item.subtitle.isNotEmpty)
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
                            item.date,
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
                              'Look IA',
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 8, letterSpacing: 0.5, color: Colors.black45),
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

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.black.withValues(alpha: 0.05),
      child: Center(
        child: Icon(Icons.image_outlined, size: 28, color: Colors.black.withValues(alpha: 0.2)),
      ),
    );
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
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Historial Looks Generados', style: TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.negroCarbon, letterSpacing: -1.0, height: 1.0)),
                    SizedBox(height: 8),
                    Text('Tus peinados y collages creados con IA', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),

              Expanded(
                child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.negroCarbon))
                  : _items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open_outlined, size: 40, color: Colors.black.withValues(alpha: 0.1)),
                            const SizedBox(height: 12),
                            const Text('Aún no hay looks generados', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black38)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  title: const Text('Eliminar look', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600)),
                                  content: Text('¿Seguro que quieres eliminar "${item.clientName}"?', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black54)),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar', style: TextStyle(fontFamily: 'Poppins', fontSize: 12))),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.redAccent))),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await _hairstyleRepo.deleteResult(item.id);
                                _loadData();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppColors.negroCarbon,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      content: const Text('Look eliminado', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                                    ),
                                  );
                                }
                              }
                              return false;
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
                            ),
                            child: _buildCard(item),
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
  final String clientName;
  final String subtitle;
  final String date;
  final String photoPath;

  const _GalleryItem({
    required this.id,
    required this.clientName,
    required this.subtitle,
    required this.date,
    required this.photoPath,
  });
}
