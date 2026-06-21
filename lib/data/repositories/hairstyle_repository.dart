import '../../domain/models/hairstyle_result_model.dart';
import '../database_helper.dart';

class HairstyleRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> saveResult(HairstyleResultModel result) async {
    return await _dbHelper.insertHairstyleResult(result.toMap());
  }

  Future<List<HairstyleResultModel>> getResultsByUser(int userId) async {
    final data = await _dbHelper.getHairstyleResultsByUser(userId);
    return data.map((json) => HairstyleResultModel.fromMap(json)).toList();
  }

  Future<List<HairstyleResultModel>> getResultsByColorimetry(int colorimetryId) async {
    final data = await _dbHelper.getHairstyleResultsByColorimetry(colorimetryId);
    return data.map((json) => HairstyleResultModel.fromMap(json)).toList();
  }

  Future<HairstyleResultModel?> getResultById(int id) async {
    final data = await _dbHelper.getHairstyleResultById(id);
    if (data != null) {
      return HairstyleResultModel.fromMap(data);
    }
    return null;
  }
}
