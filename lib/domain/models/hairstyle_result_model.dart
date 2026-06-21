class HairstyleResultModel {
  final int? id;
  final int userId;
  final int? colorimetryResultId;
  final String originalPhotoPath;
  final String hairstyleName;
  final String resultImageUrl;
  final String createdAt;
  final String personName;

  const HairstyleResultModel({
    this.id,
    required this.userId,
    this.colorimetryResultId,
    required this.originalPhotoPath,
    required this.hairstyleName,
    required this.resultImageUrl,
    required this.createdAt,
    this.personName = '',
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'user_id': userId,
    if (colorimetryResultId != null) 'colorimetry_result_id': colorimetryResultId,
    'original_photo_path': originalPhotoPath,
    'hairstyle_name': hairstyleName,
    'result_image_url': resultImageUrl,
    'created_at': createdAt,
    'person_name': personName,
  };

  factory HairstyleResultModel.fromMap(Map<String, dynamic> map) => HairstyleResultModel(
    id: map['id'] as int?,
    userId: map['user_id'] as int,
    colorimetryResultId: map['colorimetry_result_id'] as int?,
    originalPhotoPath: map['original_photo_path'] as String,
    hairstyleName: map['hairstyle_name'] as String,
    resultImageUrl: map['result_image_url'] as String,
    createdAt: map['created_at'] as String,
    personName: (map['person_name'] as String?) ?? '',
  );
}
