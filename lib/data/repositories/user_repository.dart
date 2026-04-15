import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../domain/models/user_model.dart';
import '../../core/session_manager.dart';
import '../database_helper.dart';

class UserRepository {
  final _db = DatabaseHelper.instance;

  // ─── Utilidades ──────────────────────────────────────────

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // ─── Autenticación ───────────────────────────────────────

  /// Registra un nuevo usuario. Devuelve el modelo con id asignado o null si
  /// el correo ya está en uso.
  Future<UserModel?> register(String name, String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedName = name.trim();
    final normalizedPassword = password.trim();
    try {
      final existing = await _db.getUserByEmail(normalizedEmail);
      if (existing != null) return null; // Email ya registrado

      final user = UserModel(
        name: normalizedName,
        email: normalizedEmail,
        passwordHash: _hashPassword(normalizedPassword),
        createdAt: DateTime.now().toIso8601String(),
      );

      final id = await _db.insertUser(user.toMap());
      return user.copyWith(id: id);
    } catch (_) {
      return null;
    }
  }

  /// Valida credenciales. Devuelve el usuario o null si son incorrectas.
  Future<UserModel?> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();
    try {
      final row = await _db.getUserByEmail(normalizedEmail);
      if (row == null) return null;

      final user = UserModel.fromMap(row);
      if (user.passwordHash != _hashPassword(normalizedPassword)) return null;

      return user;
    } catch (_) {
      return null;
    }
  }

  // ─── Sesión actual ───────────────────────────────────────

  Future<UserModel?> getCurrentUser() async {
    final userId = await SessionManager.getLoggedInUserId();
    if (userId == null) return null;

    final row = await _db.getUserById(userId);
    return row != null ? UserModel.fromMap(row) : null;
  }

  // ─── Actualización de datos ──────────────────────────────

  Future<bool> updateName(int userId, String newName) async {
    final rows = await _db.updateUser(userId, {'name': newName.trim()});
    return rows > 0;
  }

  Future<bool> updatePassword(
    int userId,
    String currentPassword,
    String newPassword,
  ) async {
    final row = await _db.getUserById(userId);
    if (row == null) return false;

    final user = UserModel.fromMap(row);
    if (user.passwordHash != _hashPassword(currentPassword)) return false;

    final rows = await _db.updateUser(userId, {
      'password_hash': _hashPassword(newPassword),
    });
    return rows > 0;
  }

  /// Copia la foto elegida al directorio de documentos de la app y guarda la ruta.
  Future<String?> updatePhoto(int userId, String sourcePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_$userId.jpg';
      final destPath = p.join(appDir.path, fileName);

      // Borrar foto previa si existe
      final existing = File(destPath);
      if (await existing.exists()) await existing.delete();

      await File(sourcePath).copy(destPath);
      await _db.updateUser(userId, {'profile_photo': destPath});
      return destPath;
    } catch (_) {
      return null;
    }
  }

  // ─── Estadísticas ────────────────────────────────────────

  Future<int> getColorimetryCount(int userId) =>
      _db.countColorimetryResults(userId);

  Future<int> getHairstyleCount(int userId) =>
      _db.countHairstyleResults(userId);
}
