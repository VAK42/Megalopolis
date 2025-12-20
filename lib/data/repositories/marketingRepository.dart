import '../../core/database/databaseHelper.dart';
class MarketingRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  Future<List<Map<String, dynamic>>> getPromotions() async {
    final db = await dbHelper.database;
    return await db.query('promotions', orderBy: 'endDate ASC');
  }
  Future<List<Map<String, dynamic>>> getBadges(String userId) async {
    return [
      {'name': 'Early Adopter', 'icon': 'star', 'achieved': true},
      {'name': 'Power User', 'icon': 'bolt', 'achieved': true},
      {'name': 'Top Reviewer', 'icon': 'rate_review', 'achieved': false},
    ];
  }
}