import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['TODAS', 'COLORIMETRÍA', 'PEINADOS'];

  final List<_GalleryItem> _items = [
    _GalleryItem(type: 'COLORIMETRÍA', label: 'Primavera Cálida', date: '12 ABR', color: Color(0xFFC2547A)),
    _GalleryItem(type: 'PEINADO', label: 'Bob Caoba', date: '08 ABR', color: Color(0xFF7C5CBF)),
    _GalleryItem(type: 'COLORIMETRÍA', label: 'Otoño Suave', date: '02 ABR', color: Color(0xFFD4721A)),
    _GalleryItem(type: 'PEINADO', label: 'Largo Rizado', date: '28 MAR', color: Color(0xFF3A6FD8)),
    _GalleryItem(type: 'COLORIMETRÍA', label: 'Invierno Profundo', date: '20 MAR', color: Color(0xFF2E5E8E)),
    _GalleryItem(type: 'PEINADO', label: 'Pixie Texturizado', date: '15 MAR', color: Color(0xFF2E9E6E)),
  ];

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
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final item = _filtered[index];
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        item.type == 'COLORIMETRÍA'
                            ? '/colorimetry_detail'
                            : '/hairstyle_display',
                      ),
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
  final String type;
  final String label;
  final String date;
  final Color color;

  const _GalleryItem({
    required this.type,
    required this.label,
    required this.date,
    required this.color,
  });
}
