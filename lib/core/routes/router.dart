import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routeNames.dart';
import '../../features/auth/screens/splashScreen.dart';
import '../../features/auth/screens/loginScreen.dart';
import '../../features/auth/screens/registerScreen.dart';
import '../../features/mart/screens/martHomeScreen.dart';
import '../../features/food/screens/foodHomeScreen.dart';
import '../../features/wallet/screens/walletHomeScreen.dart';
import '../../features/wallet/screens/walletCardDetailScreen.dart';
import '../../features/wallet/screens/walletBillPaymentsScreen.dart';
import '../../features/wallet/screens/walletBankAccountsScreen.dart';
import '../../features/wallet/screens/walletSendScreen.dart';
import '../../features/wallet/screens/walletRequestScreen.dart';
import '../../features/wallet/screens/walletTopUpScreen.dart';
import '../../features/wallet/screens/walletScanScreen.dart';
import '../../features/wallet/screens/walletCardsScreen.dart';
import '../../features/wallet/screens/walletTransactionsScreen.dart';
import '../../features/wallet/screens/walletAddCardScreen.dart';
import '../../features/services/screens/servicesHomeScreen.dart';
import '../../features/services/screens/serviceDetailScreen.dart';
import '../../features/profile/screens/profileScreen.dart';
import '../../features/chat/screens/chatInboxScreen.dart';
import '../../features/chat/screens/chatConversationScreen.dart';
import '../../features/chat/screens/contactsScreen.dart';
import '../../features/admin/screens/adminDashboardScreen.dart';
import '../../features/admin/screens/adminUsersScreen.dart';
import '../../features/admin/screens/adminOrdersScreen.dart';
import '../../features/driver/screens/driverDashboardScreen.dart';
import '../../features/driver/screens/driverTripsScreen.dart';
import '../../features/driver/screens/driverEarningsScreen.dart';
import '../../features/driver/screens/driverPerformanceScreen.dart';
import '../../features/driver/screens/driverIncentivesScreen.dart';
import '../../features/driver/screens/driverTrainingScreen.dart';
import '../../features/driver/screens/driverDocumentsScreen.dart';
final routerProvider = Provider<GoRouter>((ref) {
 return GoRouter(
  initialLocation: Routes.splash,
  routes: [
   GoRoute(path: Routes.splash, builder: (context, state) => const SplashScreen()),
   GoRoute(path: Routes.login, builder: (context, state) => const LoginScreen()),
   GoRoute(path: Routes.register, builder: (context, state) => const RegisterScreen()),
   GoRoute(path: '/chat/inbox', builder: (context, state) => const ChatInboxScreen()),
   GoRoute(
    path: Routes.chatConversation,
    builder: (context, state) {
     final chatId = state.pathParameters['chatId'] ?? '';
     return ChatConversationScreen(chatId: chatId);
    },
   ),
   GoRoute(path: '/contacts', builder: (context, state) => const ContactsScreen()),
   GoRoute(path: Routes.adminDashboard, builder: (context, state) => const AdminDashboardScreen()),
   GoRoute(path: Routes.adminUsers, builder: (context, state) => const AdminUsersScreen()),
   GoRoute(path: Routes.adminOrders, builder: (context, state) => const AdminOrdersScreen()),
   GoRoute(path: Routes.driverDashboard, builder: (context, state) => const DriverDashboardScreen()),
   GoRoute(path: Routes.driverTrips, builder: (context, state) => const DriverTripsScreen()),
   GoRoute(path: Routes.driverEarnings, builder: (context, state) => const DriverEarningsScreen()),
   GoRoute(path: Routes.driverPerformance, builder: (context, state) => const DriverPerformanceScreen()),
   GoRoute(path: Routes.driverIncentives, builder: (context, state) => const DriverIncentivesScreen()),
   GoRoute(path: Routes.driverTraining, builder: (context, state) => const DriverTrainingScreen()),
   GoRoute(path: Routes.driverDocuments, builder: (context, state) => const DriverDocumentsScreen()),
   StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
     return ScaffoldWithNavBar(navigationShell: navigationShell);
    },
    branches: [
     StatefulShellBranch(
      routes: [GoRoute(path: Routes.martHome, builder: (context, state) => const MartHomeScreen())],
     ),
     StatefulShellBranch(
      routes: [GoRoute(path: Routes.foodHome, builder: (context, state) => const FoodHomeScreen())],
     ),
     StatefulShellBranch(
      routes: [
       GoRoute(
        path: Routes.walletHome,
        builder: (context, state) => const WalletHomeScreen(),
        routes: [
         GoRoute(
          path: 'card/:id',
          builder: (context, state) {
           return const WalletCardDetailScreen();
          },
         ),
         GoRoute(path: 'billPayment', builder: (context, state) => const WalletBillPaymentsScreen()),
         GoRoute(path: 'linkedBanks', builder: (context, state) => const WalletBankAccountsScreen()),
         GoRoute(path: 'send', builder: (context, state) => const WalletSendScreen()),
         GoRoute(path: 'request', builder: (context, state) => const WalletRequestScreen()),
         GoRoute(path: 'topUp', builder: (context, state) => const WalletTopUpScreen()),
         GoRoute(path: 'scan', builder: (context, state) => const WalletScanScreen()),
         GoRoute(path: 'cards', builder: (context, state) => const WalletCardsScreen()),
         GoRoute(path: 'transactions', builder: (context, state) => const WalletTransactionsScreen()),
         GoRoute(path: 'addCard', builder: (context, state) => const WalletAddCardScreen()),
        ],
       ),
      ],
     ),
     StatefulShellBranch(
      routes: [
       GoRoute(
        path: Routes.servicesHome,
        builder: (context, state) => const ServicesHomeScreen(),
        routes: [
         GoRoute(
          path: 'item/:id',
          builder: (context, state) {
           final id = state.pathParameters['id'];
           return ServiceDetailScreen(serviceId: id);
          },
         ),
        ],
       ),
      ],
     ),
     StatefulShellBranch(
      routes: [GoRoute(path: Routes.profileHome, builder: (context, state) => const ProfileScreen())],
     ),
    ],
   ),
  ],
 );
});
class ScaffoldWithNavBar extends StatelessWidget {
 const ScaffoldWithNavBar({required this.navigationShell, Key? key}) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));
 final StatefulNavigationShell navigationShell;
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   body: navigationShell,
   bottomNavigationBar: NavigationBar(
    selectedIndex: navigationShell.currentIndex,
    onDestinationSelected: (int index) => _onTap(context, index),
    destinations: const [
     NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag), label: 'Mart'),
     NavigationDestination(icon: Icon(Icons.restaurant_outlined), selectedIcon: Icon(Icons.restaurant), label: 'Food'),
     NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
     NavigationDestination(icon: Icon(Icons.handyman_outlined), selectedIcon: Icon(Icons.handyman), label: 'Services'),
     NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
    ],
   ),
  );
 }
 void _onTap(BuildContext context, int index) {
  navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
 }
}