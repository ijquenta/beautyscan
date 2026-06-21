class HairstyleResultModel {
  final int? id;
  final int userId;
  final String originalPhotoPath;
  final String hairstyleName;
  final String resultImageUrl;
  final String createdAt;

  const HairstyleResultModel({
    this.id,
    required this.userId,
    required this.originalPhotoPath,
    required this.hairstyleName,
    required this.resultImageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'user_id': userId,
    'original_photo_path': originalPhotoPath,
    'hairstyle_name': hairstyleName,
    'result_image_url': resultImageUrl,
    'created_at': createdAt,
  };

  factory HairstyleResultModel.fromMap(Map<String, dynamic> map) => HairstyleResultModel(
    id: map['id'] as int?,
    userId: map['user_id'] as int,
    originalPhotoPath: map['original_photo_path'] as String,
    hairstyleName: map['hairstyle_name'] as String,
    resultImageUrl: map['result_image_url'] as String,
    createdAt: map['created_at'] as String,
  );
}
