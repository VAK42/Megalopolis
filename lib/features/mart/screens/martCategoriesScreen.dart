import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../constants/martConstants.dart';
class MartCategoriesScreen extends ConsumerWidget {
 const MartCategoriesScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final categories = [
   {'icon': Icons.phone_android, 'name': MartConstants.electronics, 'count': 1234, 'color': AppColors.primary},
   {'icon': Icons.checkroom, 'name': MartConstants.fashion, 'count': 3456, 'color': AppColors.accent},
   {'icon': Icons.home, 'name': MartConstants.homeLiving, 'count': 987, 'color': AppColors.success},
   {'icon': Icons.sports_basketball, 'name': MartConstants.sports, 'count': 654, 'color': Colors.orange},
   {'icon': Icons.book, 'name': MartConstants.books, 'count': 2345, 'color': Colors.purple},
   {'icon': Icons.toys, 'name': MartConstants.toysGames, 'count': 876, 'color': Colors.pink},
   {'icon': Icons.health_and_safety, 'name': MartConstants.healthBeauty, 'count': 1567, 'color': Colors.teal},
   {'icon': Icons.restaurant, 'name': MartConstants.foodGrocery, 'count': 4321, 'color': Colors.brown},
   {'icon': Icons.build, 'name': MartConstants.tools, 'count': 432, 'color': Colors.blueGrey},
   {'icon': Icons.pets, 'name': MartConstants.petSupplies, 'count': 765, 'color': Colors.deepOrange},
   {'icon': Icons.child_care, 'name': MartConstants.babyKids, 'count': 1098, 'color': Colors.lightBlue},
   {'icon': Icons.directions_car, 'name': MartConstants.automotive, 'count': 543, 'color': Colors.grey},
  ];
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(Routes.martHome)),
    title: const Text(MartConstants.allCategories),
   ),
   body: GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.85),
    itemCount: categories.length,
    itemBuilder: (context, index) {
     final category = categories[index];
     return GestureDetector(
      onTap: () => context.go(Routes.martProducts),
      child: Container(
       decoration: BoxDecoration(color: (category['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: (category['color'] as Color).withValues(alpha: 0.2), shape: BoxShape.circle),
          child: Icon(category['icon'] as IconData, color: category['color'] as Color, size: 32),
         ),
         const SizedBox(height: 8),
         Text(
          category['name'] as String,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          maxLines: 2,
         ),
         const SizedBox(height: 4),
         Text('${category['count']} ${MartConstants.items}', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
       ),
      ),
     );
    },
   ),
  );
 }
}