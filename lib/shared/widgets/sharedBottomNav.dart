import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/routeNames.dart';
import '../../core/theme/colors.dart';
class SharedBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell? navigationShell;
  const SharedBottomNavBar({super.key, this.navigationShell});
  @override
  Widget build(BuildContext context) {
    final currentPath = navigationShell == null ? GoRouterState.of(context).uri.toString() : '';
    final navItems = [
      _NavBarItem(icon: Icons.home, label: 'Home', route: Routes.superDashboard),
      _NavBarItem(icon: Icons.shopping_bag, label: 'Mart', route: Routes.martHome, shellIndex: 0),
      _NavBarItem(icon: Icons.restaurant, label: 'Food', route: Routes.foodHome, shellIndex: 1),
      _NavBarItem(icon: Icons.local_taxi, label: 'Ride', route: Routes.rideHome),
      _NavBarItem(icon: Icons.handyman, label: 'Services', route: Routes.servicesHome, shellIndex: 3),
      _NavBarItem(icon: Icons.account_balance_wallet, label: 'Wallet', route: Routes.walletHome, shellIndex: 2),
      _NavBarItem(icon: Icons.receipt_long, label: 'Orders', route: Routes.martOrders),
      _NavBarItem(icon: Icons.favorite, label: 'Favorites', route: Routes.martWishlist),
      _NavBarItem(icon: Icons.person, label: 'Profile', route: Routes.profileHome, shellIndex: 4),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: navItems.map((item) {
                final isActive = navigationShell != null 
                  ? (item.shellIndex != null && navigationShell!.currentIndex == item.shellIndex)
                  : currentPath.startsWith(item.route);
                return InkWell(
                  onTap: () {
                    if (navigationShell != null && item.shellIndex != null) {
                      navigationShell!.goBranch(item.shellIndex!, initialLocation: item.shellIndex == navigationShell!.currentIndex);
                    } else {
                      context.go(item.route);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item.icon, color: isActive ? AppColors.primary : Colors.grey, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                            color: isActive ? AppColors.primary : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
class _NavBarItem {
  final IconData icon;
  final String label;
  final String route;
  final int? shellIndex;
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.route,
    this.shellIndex,
  });
}