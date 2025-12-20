import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/databaseSeeder.dart';
import 'core/routes/router.dart';
import 'core/theme/colors.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final seeder = DatabaseSeeder();
    await seeder.seed();
  } catch (e) {
    debugPrint('Database Seeding Failed: $e');
  }
  runApp(const ProviderScope(child: MainApp()));
}
class MainApp extends ConsumerWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Megalopolis',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}