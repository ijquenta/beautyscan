import 'package:flutter/material.dart';
import '../../domain/models/colorimetry_result_model.dart';
import '../../data/repositories/colorimetry_repository.dart';
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
  final UserRepository _userRepo = UserRepository();
  final List<String> _filters = ['TODAS', 'COLORIMETRÍA', 'PEINADOS'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _userRepo.getCurrentUser();
    if (user != null) {
      final colorimetryData = await _colorimetryRepo.getResultsByUser(user.id!);
      
      final mappedItems = colorimetryData.map((c) {
        Color baseColor = Colors.black87; // fallback
        if (c.recommendedColors.isNotEmpty) {
          baseColor = _hexToColor(c.recommendedColors.first);
        }
        
        return _GalleryItem(
          id: c.id!,
          type: 'COLORIMETRÍA',
          label: c.season,
          date: _formatDate(c.createdAt),
          color: baseColor,
          route: '/analysis_results',
        );
      }).toList();

      if (mounted) {
        setState(() {
          _items = mappedItems;
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
      return '${dt.day} ${_getMonth(dt.month)}'.toUpperCase();
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
    final filterType = _selectedFilter == 1 ? 'COLORIMETRÍA' : 'PEINADO';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'EL ARCHIVO',
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
                      'Galería.',
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

              // Busqueda y Filtros minimalistas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12, width: 1.5)),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'BUSCAR...',
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              letterSpacing: 2.0,
                              color: Colors.black38,
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            letterSpacing: 2.0,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const Text(
                        'BUSCAR',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              
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
                        margin: const EdgeInsets.only(right: 24),
                        padding: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isActive ? Colors.black87 : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                        ),
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
                  }).toList(),
                ),
              ),

              const SizedBox(height: 48),

              // Lista Galeria Minimalista
              Expanded(
                child: _isLoading 
                  ? const Center(child: Text('CARGANDO...', style: TextStyle(fontFamily: 'Inter', letterSpacing: 2.0)))
                  : _filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'GALERÍA VACÍA',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            letterSpacing: 3.0,
                            color: Colors.black38,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          final item = _filtered[index];
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(context, item.route, arguments: item.id),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 32),
                              color: Colors.transparent,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    color: item.color.withValues(alpha: 0.1),
                                    child: Center(
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        color: item.color,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.label,
                                          style: const TextStyle(
                                            fontFamily: 'PlayfairDisplay',
                                            fontSize: 20,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              item.type,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 9,
                                                color: Colors.black54,
                                                letterSpacing: 2.0,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              item.date,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 9,
                                                color: Colors.black38,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
  final String label;
  final String date;
  final Color color;
  final String route;

  const _GalleryItem({
    required this.id,
    required this.type,
    required this.label,
    required this.date,
    required this.color,
    required this.route,
  });
}
