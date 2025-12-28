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
 }
}