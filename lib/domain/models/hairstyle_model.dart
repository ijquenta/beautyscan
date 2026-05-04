import 'package:flutter/material.dart';

/// Producto recomendado para un estilo dado (usado dentro de HairstyleModel).
class HairstyleProduct {
  final String name;
  final String brand;
  final String use;

  const HairstyleProduct({
    required this.name,
    required this.brand,
    required this.use,
  });
}

/// Representa un estilo de peinado disponible para simular.
class HairstyleModel {
  final String id;
  final String name;
  final String description;
  final String styleType; // 'rizado', 'corto', 'bob', 'flequillo', etc.
  final String maintenanceLevel; // 'Bajo', 'Moderado', 'Alto'
  final Color accentColor;
  final List<String> stylistSteps;
  final List<HairstyleProduct> products;
  final String imagePath;

  const HairstyleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.styleType,
    required this.maintenanceLevel,
    required this.accentColor,
    required this.stylistSteps,
    required this.products,
    required this.imagePath,
  });

  /// Catálogo de estilos disponibles para el carrusel.
  static const List<HairstyleModel> catalog = [
    HairstyleModel(
      id: 'rizos_naturales',
      name: 'Rizos\nNaturales',
      description: 'Definición de rizos con técnica Curly Girl. Realza la '
          'textura natural con hidratación profunda y fijación ligera.',
      styleType: 'rizado',
      maintenanceLevel: 'Moderado',
      accentColor: Color(0xFFD4845A),
      stylistSteps: [
        'Lavar con champú sin sulfatos y aplicar acondicionador abundante.',
        'Aplicar gel rizador en secciones con el cabello húmedo ("praying hands").',
        'Difusar a temperatura media hasta secar al 80 %.',
        'Romper el cast con aceite de argán para definir sin apelmazar.',
      ],
      products: [
        HairstyleProduct(name: 'GEL RIZADOR', brand: 'Mielle Organics', use: 'Definición'),
        HairstyleProduct(name: 'LEAVE-IN', brand: 'Shea Moisture', use: 'Hidratación'),
        HairstyleProduct(name: 'ACEITE ARGÁN', brand: 'Moroccanoil', use: 'Acabado'),
      ],
      imagePath: 'assets/images/look-rizos-naturales.png',
    ),
    HairstyleModel(
      id: 'corte_pixie',
      name: 'Pixie\nCut',
      description: 'Corte ultra corto y atrevido que enmarca el rostro. '
          'Ideal para rostros ovalados y cuadrados con frente amplia.',
      styleType: 'corto',
      maintenanceLevel: 'Alto',
      accentColor: Color(0xFF4A9E8C),
      stylistSteps: [
        'Cortar la nuca y los lados con maquinilla nº 3 / nº 4.',
        'Trabajar la coronilla con tijera texturizadora para volumen.',
        'Aplicar pasta de fijación ligera con los dedos en la parte superior.',
        'Secar con cepillo redondo pequeño para definir el flequillo lateral.',
      ],
      products: [
        HairstyleProduct(name: 'PASTA TEXTURIZADORA', brand: 'American Crew', use: 'Fijación'),
        HairstyleProduct(name: 'SÉRUM BRILLO', brand: 'Redken', use: 'Acabado'),
        HairstyleProduct(name: 'SPRAY VOLUMEN', brand: 'Wella', use: 'Volumen'),
      ],
      imagePath: 'assets/images/look-pixie-cut.png',
    ),
    HairstyleModel(
      id: 'bob_texturizado',
      name: 'Bob\nTexturizado',
      description: 'Corte bob con capas texturizadas y tinte caoba cálido '
          'que realza tu temporada natural.',
      styleType: 'bob',
      maintenanceLevel: 'Moderado',
      accentColor: Color(0xFFC2547A),
      stylistSteps: [
        'Decoloración en mechones superiores pre-tinte.',
        'Tinte 6.45 (caoba cálido) por toda la longitud (35 min).',
        'Corte bob, altura del mentón con capas internas.',
        'Ondas con plancha 32 mm, finalizando con aceite argán.',
      ],
      products: [
        HairstyleProduct(name: '6.45 CAOBA', brand: 'Koleston Perfect', use: 'Tinte'),
        HairstyleProduct(name: 'MASCARILLA', brand: 'Kérastase Nutritive', use: 'Reparador'),
        HairstyleProduct(name: 'ACEITE ARGÁN', brand: 'Moroccanoil', use: 'Acabado'),
      ],
      imagePath: 'assets/images/look-bob-texturizado.png',
    ),
    HairstyleModel(
      id: 'flequillo_cortina',
      name: 'Flequillo\nCortina',
      description: 'Flequillo partido al centro con capas largas suaves. '
          'Tendencia noventera que alarga visualmente el rostro.',
      styleType: 'flequillo',
      maintenanceLevel: 'Bajo',
      accentColor: Color(0xFF8BAE50),
      stylistSteps: [
        'Separar el triángulo frontal y cortar a la altura de la nariz.',
        'Partir al centro y dejar caer a ambos lados de forma natural.',
        'Utilizar plancha de 25 mm para crear la curva hacia afuera suave.',
        'Fijar con laca ligera de acabado natural.',
      ],
      products: [
        HairstyleProduct(name: 'SÉRUM ANTIFRIZZ', brand: 'L\'Oréal Elvive', use: 'Control'),
        HairstyleProduct(name: 'PLANCHA 25MM', brand: 'GHD Gold', use: 'Herramienta'),
        HairstyleProduct(name: 'LACA LIGERA', brand: 'Schwarzkopf', use: 'Acabado'),
      ],
      imagePath: 'assets/images/look-flequillo-cortina.png',
    ),
  ];
}

