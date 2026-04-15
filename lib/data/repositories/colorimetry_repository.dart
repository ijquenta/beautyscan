import '../../domain/models/colorimetry_result_model.dart';
import '../database_helper.dart';

class ColorimetryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> saveResult(ColorimetryResultModel result) async {
    return await _dbHelper.insertColorimetryResult(result.toMap());
  }

  Future<List<ColorimetryResultModel>> getResultsByUser(int userId) async {
    final data = await _dbHelper.getColorimetryResultsByUser(userId);
    return data.map((json) => ColorimetryResultModel.fromMap(json)).toList();
  }

  Future<ColorimetryResultModel?> getResultById(int id) async {
    final data = await _dbHelper.getColorimetryResultById(id);
    if (data != null) {
      return ColorimetryResultModel.fromMap(data);
    }
    return null;
  }
}
