import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../components/atoms/beauty_background.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedTab = 0;

  final List<_HistoryEntry> _entries = [
    _HistoryEntry(
      type: 'Colorimetría',
      result: 'Primavera Cálida',
      detail: 'Subtono cálido · Contraste medio',
      date: '12 abr 2026',
      route: '/colorimetry_detail',
    ),
    _HistoryEntry(
      type: 'Peinado IA',
      result: 'Bob Caoba Cálida',
      detail: 'Corte bob · Tinte caoba',
      date: '8 abr 2026',
      route: '/hairstyle_display',
    ),
    _HistoryEntry(
      type: 'Colorimetría',
      result: 'Otoño Suave',
      detail: 'Subtono terroso · Contraste suave',
      date: '2 abr 2026',
      route: '/colorimetry_detail',
    ),
    _HistoryEntry(
      type: 'Peinado IA',
      result: 'Largo Ondulado Natural',
      detail: 'Sin corte · Tinte rubio miel',
      date: '28 mar 2026',
      route: '/hairstyle_display',
    ),
    _HistoryEntry(
      type: 'Colorimetría',
      result: 'Invierno Profundo',
      detail: 'Subtono frío · Contraste alto',
      date: '20 mar 2026',
      route: '/colorimetry_detail', // fixed duplicate from above
    ),
  ];

  List<_HistoryEntry> get _filtered {
    if (_selectedTab == 0) return _entries;
    final type = _selectedTab == 1 ? 'Colorimetría' : 'Peinado IA';
    return _entries.where((e) => e.type == type).toList();
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
              // Header Typography
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
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
                      'Tu historia\nde estilo.',
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

              // Typographical Filters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: ['TODOS', 'COLORES', 'PEINADOS']
                      .asMap()
                      .entries
                      .map((entry) {
                    final i = entry.key;
                    final label = entry.value;
                    final isActive = i == _selectedTab;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
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

              const SizedBox(height: 32),

              // List
              Expanded(
                child: _filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'ARCHIVO VACÍO',
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
                          final entry = _filtered[index];
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(context, entry.route),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 32),
                              color: Colors.transparent, // tap area
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      entry.date.toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black38,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry.result,
                                          style: const TextStyle(
                                            fontFamily: 'PlayfairDisplay',
                                            fontSize: 20,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          entry.type.toUpperCase(),
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 9,
                                            color: Colors.black54,
                                            letterSpacing: 2.0,
                                          ),
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

class _HistoryEntry {
  final String type;
  final String result;
  final String detail;
  final String date;
  final String route;

  const _HistoryEntry({
    required this.type,
    required this.result,
    required this.detail,
    required this.date,
    required this.route,
  });
}
