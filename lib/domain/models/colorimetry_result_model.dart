import 'dart:convert';

import 'hair_colorimetry_result.dart';

class ColorimetryResultModel {
  final int? id;
  final int userId;
  final String clientName;
  final String photoPath;
  final String skinTone;
  final String undertone;
  final String season;
  final List<String> recommendedColors; // Hex codes without #
  final List<String> colorsToAvoid; // Hex codes without #
  final String? makeupTips;
  final String createdAt;
  final String? hairResultJson;

  const ColorimetryResultModel({
    this.id,
    required this.userId,
    required this.clientName,
    required this.photoPath,
    required this.skinTone,
    required this.undertone,
    required this.season,
    required this.recommendedColors,
    required this.colorsToAvoid,
    this.makeupTips,
    required this.createdAt,
    this.hairResultJson,
  });

  HairColorimetryResult? get hairResult {
    if (hairResultJson == null) return null;
    try {
      return HairColorimetryResult.fromJsonString(hairResultJson!);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'client_name': clientName,
      'photo_path': photoPath,
      'skin_tone': skinTone,
      'undertone': undertone,
      'season': season,
      'recommended_colors': jsonEncode(recommendedColors),
      'colors_to_avoid': jsonEncode(colorsToAvoid),
      'makeup_tips': makeupTips,
      'created_at': createdAt,
      if (hairResultJson != null) 'hair_result_json': hairResultJson,
    };
  }

  factory ColorimetryResultModel.fromMap(Map<String, dynamic> map) {
    return ColorimetryResultModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      clientName: map['client_name'] as String? ?? 'Cliente',
      photoPath: map['photo_path'] as String,
      skinTone: map['skin_tone'] as String,
      undertone: map['undertone'] as String,
      season: map['season'] as String,
      recommendedColors: List<String>.from(jsonDecode(map['recommended_colors'] as String)),
      colorsToAvoid: List<String>.from(jsonDecode(map['colors_to_avoid'] as String)),
      makeupTips: map['makeup_tips'] as String?,
      createdAt: map['created_at'] as String,
      hairResultJson: map['hair_result_json'] as String?,
    );
  }
}
