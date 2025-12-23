import '../database/databaseHelper.dart';
class AppConstants {
 static String appName = 'Megalopolis';
 static String appVersion = '1.0.0';
 static double borderRadius = 12.0;
 static double cardBorderRadius = 16.0;
 static double paddingSmall = 8.0;
 static double paddingMedium = 16.0;
 static double paddingLarge = 24.0;
 static double iconSizeSmall = 16.0;
 static double iconSizeMedium = 24.0;
 static double iconSizeLarge = 32.0;
 static double elevationLow = 2.0;
 static double elevationMedium = 4.0;
 static double elevationHigh = 8.0;
 static String currencySymbol = '\$';
 static int animationDurationMs = 300;
 static int shimmerDurationMs = 1500;
 static Duration searchDebounce = const Duration(milliseconds: 500);
 static Future<void> loadFromDatabase() async {
  final db = await DatabaseHelper.instance.database;
  final settings = await db.query('appSettings');
  for (var setting in settings) {
   final key = setting['key'] as String;
   final value = setting['value'] as String;
   final _ = setting['type'] as String;
   switch (key) {
    case 'appName':
     appName = value;
     break;
    case 'appVersion':
     appVersion = value;
     break;
    case 'currencySymbol':
     currencySymbol = value;
     break;
    case 'borderRadius':
     borderRadius = double.tryParse(value) ?? 12.0;
     break;
    case 'cardBorderRadius':
     cardBorderRadius = double.tryParse(value) ?? 16.0;
     break;
    case 'paddingSmall':
     paddingSmall = double.tryParse(value) ?? 8.0;
     break;
    case 'paddingMedium':
     paddingMedium = double.tryParse(value) ?? 16.0;
     break;
    case 'paddingLarge':
     paddingLarge = double.tryParse(value) ?? 24.0;
     break;
    case 'iconSizeSmall':
     iconSizeSmall = double.tryParse(value) ?? 16.0;
     break;
    case 'iconSizeMedium':
     iconSizeMedium = double.tryParse(value) ?? 24.0;
     break;
    case 'iconSizeLarge':
     iconSizeLarge = double.tryParse(value) ?? 32.0;
     break;
    case 'elevationLow':
     elevationLow = double.tryParse(value) ?? 2.0;
     break;
    case 'elevationMedium':
     elevationMedium = double.tryParse(value) ?? 4.0;
     break;
    case 'elevationHigh':
     elevationHigh = double.tryParse(value) ?? 8.0;
     break;
    case 'animationDurationMs':
     animationDurationMs = int.tryParse(value) ?? 300;
     break;
    case 'shimmerDurationMs':
     shimmerDurationMs = int.tryParse(value) ?? 1500;
     break;
    case 'searchDebounceMs':
     final ms = int.tryParse(value) ?? 500;
     searchDebounce = Duration(milliseconds: ms);
     break;
   }
  }
 }
}