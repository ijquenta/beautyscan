import 'dart:convert';

class ColorimetryResultModel {
  final int? id;
  final int userId;
  final String photoPath;
  final String skinTone;
  final String undertone;
  final String season;
  final List<String> recommendedColors; // Hex codes without #
  final List<String> colorsToAvoid; // Hex codes without #
  final String? makeupTips;
  final String createdAt;

  const ColorimetryResultModel({
    this.id,
    required this.userId,
    required this.photoPath,
    required this.skinTone,
    required this.undertone,
    required this.season,
    required this.recommendedColors,
    required this.colorsToAvoid,
    this.makeupTips,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'photo_path': photoPath,
      'skin_tone': skinTone,
      'undertone': undertone,
      'season': season,
      'recommended_colors': jsonEncode(recommendedColors),
      'colors_to_avoid': jsonEncode(colorsToAvoid),
      'makeup_tips': makeupTips,
      'created_at': createdAt,
    };
  }

  factory ColorimetryResultModel.fromMap(Map<String, dynamic> map) {
    return ColorimetryResultModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      photoPath: map['photo_path'] as String,
      skinTone: map['skin_tone'] as String,
      undertone: map['undertone'] as String,
      season: map['season'] as String,
      recommendedColors: List<String>.from(jsonDecode(map['recommended_colors'] as String)),
      colorsToAvoid: List<String>.from(jsonDecode(map['colors_to_avoid'] as String)),
      makeupTips: map['makeup_tips'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
}
