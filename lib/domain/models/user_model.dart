class UserModel {
  final int? id;
  final String name;
  final String email;
  final String passwordHash;
  final String? profilePhoto;
  final String createdAt;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.profilePhoto,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'password_hash': passwordHash,
        'profile_photo': profilePhoto,
        'created_at': createdAt,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] as int?,
        name: map['name'] as String,
        email: map['email'] as String,
        passwordHash: map['password_hash'] as String,
        profilePhoto: map['profile_photo'] as String?,
        createdAt: map['created_at'] as String,
      );

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? passwordHash,
    String? profilePhoto,
    String? createdAt,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        createdAt: createdAt ?? this.createdAt,
      );
}
