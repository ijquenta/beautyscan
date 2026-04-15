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
      color: Color(0xFFC2547A),
      route: '/colorimetry_detail',
    ),
    _HistoryEntry(
      type: 'Peinado IA',
      result: 'Bob Caoba Cálida',
      detail: 'Corte bob · Tinte caoba',
      date: '8 abr 2026',
      color: Color(0xFF7C5CBF),
      route: '/hairstyle_display',
    ),
    _HistoryEntry(
      type: 'Colorimetría',
      result: 'Otoño Suave',
      detail: 'Subtono terroso · Contraste suave',
      date: '2 abr 2026',
      color: Color(0xFFD4721A),
      route: '/colorimetry_detail',
    ),
    _HistoryEntry(
      type: 'Peinado IA',
      result: 'Largo Ondulado Natural',
      detail: 'Sin corte · Tinte rubio miel',
      date: '28 mar 2026',
      color: Color(0xFF3A6FD8),
      route: '/hairstyle_display',
    ),
    _HistoryEntry(
      type: 'Colorimetría',
      result: 'Invierno Profundo',
      detail: 'Subtono frío · Contraste alto',
      date: '20 mar 2026',
      color: Color(0xFF2E5E8E),
      route: '/colorimetry_detail',
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
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.whiteGlassmorphism,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white60, width: 1),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.black87, size: 20),
            ),
          ),
          title: Text(
            'Historial',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Tabs
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.whiteGlassmorphism,
                    borderRadius: AppConstants.pillBorderRadius,
                    border: Border.all(color: Colors.white60, width: 1),
                  ),
                  child: Row(
                    children: ['Todos', 'Colorimetría', 'Peinados']
                        .asMap()
                        .entries
                        .map((entry) {
                      final i = entry.key;
                      final label = entry.value;
                      final isActive = i == _selectedTab;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTab = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.primaryAccent : Colors.transparent,
                              borderRadius: AppConstants.pillBorderRadius,
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primaryAccent.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isActive ? Colors.white : Colors.black45,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Contador
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filtered.length} análisis',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    const Text(
                      'Más recientes primero',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.primaryAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Lista
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryAccent.withValues(alpha: 0.1),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Sin análisis aún',
                              style: TextStyle(
                                fontFamily: 'PlayfairDisplay',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Realiza tu primer escaneo',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _filtered.length,
                        separatorBuilder: (context, i) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final entry = _filtered[index];
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(context, entry.route),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppColors.whiteGlassmorphism,
                                borderRadius: AppConstants.defaultCardRadius,
                                border: Border.all(color: Colors.white60, width: 1),
                                boxShadow: const [
                                  BoxShadow(color: AppColors.shadowGlow, blurRadius: 10),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          entry.color.withValues(alpha: 0.15),
                                          entry.color.withValues(alpha: 0.25),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: entry.color,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: entry.color.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                entry.type,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                  color: entry.color,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              entry.date,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 11,
                                                color: Colors.black38,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          entry.result,
                                          style: const TextStyle(
                                            fontFamily: 'PlayfairDisplay',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          entry.detail,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.black26,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
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
  final Color color;
  final String route;

  const _HistoryEntry({
    required this.type,
    required this.result,
    required this.detail,
    required this.date,
    required this.color,
    required this.route,
  });
}
