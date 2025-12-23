import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routeNames.dart';
import '../../features/auth/screens/splashScreen.dart';
import '../../features/auth/screens/loginScreen.dart';
import '../../features/auth/screens/registerScreen.dart';
import '../../features/auth/screens/onboarding1Screen.dart';
import '../../features/auth/screens/onboarding2Screen.dart';
import '../../features/auth/screens/onboarding3Screen.dart';
import '../../features/auth/screens/welcomeScreen.dart';
import '../../features/auth/screens/verifyOtpScreen.dart';
import '../../features/auth/screens/forgotPasswordScreen.dart';
import '../../features/auth/screens/checkInboxScreen.dart';
import '../../features/auth/screens/createPasswordScreen.dart';
import '../../features/auth/screens/accountCreatedScreen.dart';
import '../../features/auth/screens/setLocationScreen.dart';
import '../../features/auth/screens/enableBiometricsScreen.dart';
import '../../features/core/screens/superDashboardScreen.dart';
import '../../features/core/screens/globalSearchScreen.dart';
import '../../features/core/screens/globalSearchResultsScreen.dart';
import '../../features/core/screens/notificationsScreen.dart';
import '../../features/core/screens/notificationDetailScreen.dart';
import '../../features/core/screens/scanQrScreen.dart';
import '../../features/core/screens/qrErrorScreen.dart';
import '../../features/core/screens/deepLinkLoadingScreen.dart';
import '../../features/mart/screens/martHomeScreen.dart';
import '../../features/mart/screens/martSearchScreen.dart';
import '../../features/mart/screens/martProductsScreen.dart';
import '../../features/mart/screens/martCategoriesScreen.dart';
import '../../features/mart/screens/martFlashSaleScreen.dart';
import '../../features/mart/screens/martProductDetailScreen.dart';
import '../../features/mart/screens/martProductReviewsScreen.dart';
import '../../features/mart/screens/martSellerProfileScreen.dart';
import '../../features/mart/screens/martCartScreen.dart';
import '../../features/mart/screens/martCheckoutScreen.dart';
import '../../features/mart/screens/martOrderPlacedScreen.dart';
import '../../features/mart/screens/martOrdersScreen.dart';
import '../../features/mart/screens/martOrderTrackingScreen.dart';
import '../../features/mart/screens/martReturnRequestScreen.dart';
import '../../features/mart/screens/martReturnSubmittedScreen.dart';
import '../../features/mart/screens/martWishlistScreen.dart';
import '../../features/mart/screens/martCompareScreen.dart';
import '../../features/mart/screens/martDealsScreen.dart';
import '../../features/mart/screens/martBrandsScreen.dart';
import '../../features/mart/screens/martCouponsScreen.dart';
import '../../features/mart/screens/martAuctionScreen.dart';
import '../../features/mart/screens/martGiftCardsScreen.dart';
import '../../features/food/screens/foodHomeScreen.dart';
import '../../features/food/screens/foodCategoryFilterScreen.dart';
import '../../features/food/screens/foodRestaurantListScreen.dart';
import '../../features/food/screens/foodRestaurantSearchScreen.dart';
import '../../features/food/screens/foodRestaurantDetailScreen.dart';
import '../../features/food/screens/foodRestaurantInfoScreen.dart';
import '../../features/food/screens/foodItemDetailScreen.dart';
import '../../features/food/screens/foodCustomizeItemScreen.dart';
import '../../features/food/screens/foodCartScreen.dart';
import '../../features/food/screens/foodCartEmptyScreen.dart';
import '../../features/food/screens/foodCheckoutAddressScreen.dart';
import '../../features/food/screens/foodCheckoutPromoScreen.dart';
import '../../features/food/screens/foodCheckoutNoteScreen.dart';
import '../../features/food/screens/foodCheckoutPaymentScreen.dart';
import '../../features/food/screens/foodPaymentProcessingScreen.dart';
import '../../features/food/screens/foodOrderPlacedScreen.dart';
import '../../features/food/screens/foodTrackingFindingDriverScreen.dart';
import '../../features/food/screens/foodTrackingPreparingScreen.dart';
import '../../features/food/screens/foodTrackingPickedUpScreen.dart';
import '../../features/food/screens/foodTrackingArrivedScreen.dart';
import '../../features/food/screens/foodMessageDriverScreen.dart';
import '../../features/food/screens/foodCallDriverScreen.dart';
import '../../features/food/screens/foodOrderCompleteScreen.dart';
import '../../features/food/screens/foodRateFoodScreen.dart';
import '../../features/food/screens/foodRateDriverScreen.dart';
import '../../features/food/screens/foodOrderHistoryScreen.dart';
import '../../features/food/screens/foodOrderDetailScreen.dart';
import '../../features/food/screens/foodFavoritesScreen.dart';
import '../../features/food/screens/foodAllergiesScreen.dart';
import '../../features/food/screens/foodNutritionScreen.dart';
import '../../features/food/screens/foodGroupOrderScreen.dart';
import '../../features/food/screens/foodTableBookingScreen.dart';
import '../../features/food/screens/foodReservationHistoryScreen.dart';
import '../../features/food/screens/foodLoyaltyScreen.dart';
import '../../features/food/screens/foodPromocodeScreen.dart';
import '../../features/ride/screens/rideHomeScreen.dart';
import '../../features/ride/screens/ridePickLocationScreen.dart';
import '../../features/ride/screens/rideSavedPlacesScreen.dart';
import '../../features/ride/screens/rideSelectVehicleScreen.dart';
import '../../features/ride/screens/ridePriceEstimateScreen.dart';
import '../../features/ride/screens/rideFindingDriverScreen.dart';
import '../../features/ride/screens/rideDriverFoundScreen.dart';
import '../../features/ride/screens/rideInProgressScreen.dart';
import '../../features/ride/screens/rideCompletedScreen.dart';
import '../../features/ride/screens/rideReceiptScreen.dart';
import '../../features/ride/screens/rideRateDriverScreen.dart';
import '../../features/ride/screens/rideMessageDriverScreen.dart';
import '../../features/ride/screens/rideCallDriverScreen.dart';
import '../../features/ride/screens/rideHistoryScreen.dart';
import '../../features/ride/screens/rideScheduleScreen.dart';
import '../../features/ride/screens/rideAddPaymentScreen.dart';
import '../../features/ride/screens/ridePaymentMethodScreen.dart';
import '../../features/ride/screens/rideEmergencyScreen.dart';
import '../../features/ride/screens/rideShareScreen.dart';
import '../../features/ride/screens/ridePassScreen.dart';
import '../../features/ride/screens/rideRentalScreen.dart';
import '../../features/ride/screens/rideInsuranceScreen.dart';
import '../../features/ride/screens/rideDriverEarningsScreen.dart';
import '../../features/wallet/screens/walletHomeScreen.dart';
import '../../features/wallet/screens/walletCardDetailScreen.dart';
import '../../features/wallet/screens/walletCardsScreen.dart';
import '../../features/wallet/screens/walletAddCardScreen.dart';
import '../../features/wallet/screens/walletTransactionsScreen.dart';
import '../../features/wallet/screens/walletSendScreen.dart';
import '../../features/wallet/screens/walletSendConfirmScreen.dart';
import '../../features/wallet/screens/walletSendSuccessScreen.dart';
import '../../features/wallet/screens/walletRequestScreen.dart';
import '../../features/wallet/screens/walletRequestSentScreen.dart';
import '../../features/wallet/screens/walletTopUpScreen.dart';
import '../../features/wallet/screens/walletTopUpConfirmScreen.dart';
import '../../features/wallet/screens/walletTopUpSuccessScreen.dart';
import '../../features/wallet/screens/walletScanScreen.dart';
import '../../features/wallet/screens/walletMyQrScreen.dart';
import '../../features/wallet/screens/walletBillPaymentsScreen.dart';
import '../../features/wallet/screens/walletPayBillScreen.dart';
import '../../features/wallet/screens/walletBankAccountsScreen.dart';
import '../../features/wallet/screens/walletWithdrawScreen.dart';
import '../../features/wallet/screens/walletBudgetScreen.dart';
import '../../features/wallet/screens/walletAnalyticsScreen.dart';
import '../../features/wallet/screens/walletInvestScreen.dart';
import '../../features/wallet/screens/walletLoanScreen.dart';
import '../../features/wallet/screens/walletCashbackScreen.dart';
import '../../features/wallet/screens/walletSplitBillScreen.dart';
import '../../features/wallet/screens/walletRecurringPaymentsScreen.dart';
import '../../features/services/screens/servicesHomeScreen.dart';
import '../../features/services/screens/serviceDetailScreen.dart';
import '../../features/services/screens/servicesSearchScreen.dart';
import '../../features/services/screens/servicesProvidersScreen.dart';
import '../../features/services/screens/servicesProviderProfileScreen.dart';
import '../../features/services/screens/servicesBookingScreen.dart';
import '../../features/services/screens/servicesBookingConfirmedScreen.dart';
import '../../features/services/screens/servicesTrackingScreen.dart';
import '../../features/services/screens/servicesChatScreen.dart';
import '../../features/services/screens/servicesHistoryScreen.dart';
import '../../features/services/screens/servicesRateScreen.dart';
import '../../features/services/screens/servicesPromoScreen.dart';
import '../../features/services/screens/servicesSubscriptionScreen.dart';
import '../../features/services/screens/servicesWarrantyScreen.dart';
import '../../features/services/screens/servicesInsuranceScreen.dart';
import '../../features/profile/screens/profileScreen.dart';
import '../../features/profile/screens/profileEditScreen.dart';
import '../../features/profile/screens/profileQrScreen.dart';
import '../../features/profile/screens/profileSecurityScreen.dart';
import '../../features/profile/screens/profileActivityScreen.dart';
import '../../features/profile/screens/membershipScreen.dart';
import '../../features/profile/screens/addressesScreen.dart';
import '../../features/profile/screens/addressAddScreen.dart';
import '../../features/profile/screens/paymentMethodsScreen.dart';
import '../../features/profile/screens/languageScreen.dart';
import '../../features/profile/screens/themeScreen.dart';
import '../../features/profile/screens/notificationSettingsScreen.dart';
import '../../features/profile/screens/privacySettingsScreen.dart';
import '../../features/profile/screens/helpCenterScreen.dart';
import '../../features/profile/screens/supportChatScreen.dart';
import '../../features/profile/screens/supportEmailScreen.dart';
import '../../features/profile/screens/supportTicketScreen.dart';
import '../../features/profile/screens/aboutScreen.dart';
import '../../features/profile/screens/settingsScreen.dart';
import '../../features/profile/screens/referralScreen.dart';
import '../../features/profile/screens/feedbackScreen.dart';
import '../../features/profile/screens/dataUsageScreen.dart';
import '../../features/chat/screens/chatInboxScreen.dart';
import '../../features/chat/screens/chatConversationScreen.dart';
import '../../features/chat/screens/contactsScreen.dart';
import '../../features/chat/screens/groupChatScreen.dart';
import '../../features/chat/screens/mediaGalleryScreen.dart';
import '../../features/chat/screens/voiceCallScreen.dart';
import '../../features/chat/screens/videoCallScreen.dart';
import '../../features/chat/screens/incomingCallScreen.dart';
import '../../features/admin/screens/adminLoginScreen.dart';
import '../../features/admin/screens/adminDashboardScreen.dart';
import '../../features/admin/screens/adminUsersScreen.dart';
import '../../features/admin/screens/adminOrdersScreen.dart';
import '../../features/admin/screens/adminAnalyticsScreen.dart';
import '../../features/admin/screens/adminPromotionsScreen.dart';
import '../../features/admin/screens/adminConfigScreen.dart';
import '../../features/admin/screens/adminReportsScreen.dart';
import '../../features/admin/screens/adminNotificationScreen.dart';
import '../../features/admin/screens/adminSupportTicketsScreen.dart';
import '../../features/admin/screens/adminContentModerationScreen.dart';
import '../../features/driver/screens/driverDashboardScreen.dart';
import '../../features/driver/screens/driverTripsScreen.dart';
import '../../features/driver/screens/driverEarningsScreen.dart';
import '../../features/driver/screens/driverPerformanceScreen.dart';
import '../../features/driver/screens/driverIncentivesScreen.dart';
import '../../features/driver/screens/driverTrainingScreen.dart';
import '../../features/driver/screens/driverDocumentsScreen.dart';
import '../../features/driver/screens/driverRegistrationScreen.dart';
import '../../features/analytics/screens/analyticsSpendingScreen.dart';
import '../../features/analytics/screens/analyticsIncomeScreen.dart';
import '../../features/analytics/screens/analyticsBudgetScreen.dart';
import '../../features/analytics/screens/analyticsSavingsScreen.dart';
import '../../features/analytics/screens/analyticsInvestmentScreen.dart';
import '../../features/analytics/screens/analyticsTaxScreen.dart';
import '../../features/analytics/screens/analyticsGoalsScreen.dart';
import '../../features/analytics/screens/analyticsComparisonScreen.dart';
import '../../features/analytics/screens/analyticsCategoryScreen.dart';
import '../../features/analytics/screens/analyticsTrendsScreen.dart';
import '../../features/analytics/screens/analyticsReportsScreen.dart';
import '../../features/marketing/screens/marketingSpinWheelScreen.dart';
import '../../features/marketing/screens/marketingScratchCardScreen.dart';
import '../../features/marketing/screens/marketingDailyCheckInScreen.dart';
import '../../features/marketing/screens/marketingLeaderboardScreen.dart';
import '../../features/marketing/screens/marketingBadgesScreen.dart';
import '../../features/marketing/screens/marketingBannersScreen.dart';
import '../../features/merchant/screens/merchantDashboardScreen.dart';
import '../../features/merchant/screens/merchantOrdersScreen.dart';
import '../../features/merchant/screens/merchantProductsScreen.dart';
import '../../features/merchant/screens/merchantInventoryScreen.dart';
import '../../features/merchant/screens/merchantPromotionsScreen.dart';
import '../../features/merchant/screens/merchantPayoutsScreen.dart';
import '../../features/merchant/screens/merchantReviewsScreen.dart';
import '../../features/merchant/screens/merchantProfileScreen.dart';
import '../../features/merchant/screens/merchantSalesScreen.dart';
import '../../features/merchant/screens/merchantRegistrationScreen.dart';
import '../../features/settings/screens/settingsAccessibilityScreen.dart';
import '../../features/settings/screens/settingsFontSizeScreen.dart';
import '../../features/settings/screens/settingsColorBlindScreen.dart';
import '../../features/settings/screens/settingsVoiceCommandsScreen.dart';
import '../../features/settings/screens/settingsNetworkScreen.dart';
import '../../features/settings/screens/settingsStorageScreen.dart';
import '../../features/settings/screens/settingsOfflineModeScreen.dart';
import '../../features/social/screens/socialFriendsScreen.dart';
import '../../features/social/screens/socialAddFriendScreen.dart';
import '../../features/social/screens/socialProfileScreen.dart';
import '../../features/social/screens/socialActivityFeedScreen.dart';
import '../../features/social/screens/socialGiftScreen.dart';
import '../../features/social/screens/socialSplitExpenseScreen.dart';
import '../../features/social/screens/socialShareLocationScreen.dart';
import '../../features/social/screens/socialChallengesScreen.dart';
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onboarding1,
        builder: (context, state) => const Onboarding1Screen(),
      ),
      GoRoute(
        path: Routes.onboarding2,
        builder: (context, state) => const Onboarding2Screen(),
      ),
      GoRoute(
        path: Routes.onboarding3,
        builder: (context, state) => const Onboarding3Screen(),
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.verifyOtp,
        builder: (context, state) => const VerifyOtpScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.checkInbox,
        builder: (context, state) => const CheckInboxScreen(),
      ),
      GoRoute(
        path: Routes.createPassword,
        builder: (context, state) => const CreatePasswordScreen(),
      ),
      GoRoute(
        path: Routes.accountCreated,
        builder: (context, state) => const AccountCreatedScreen(),
      ),
      GoRoute(
        path: Routes.setLocation,
        builder: (context, state) => const SetLocationScreen(),
      ),
      GoRoute(
        path: Routes.enableBiometrics,
        builder: (context, state) => const EnableBiometricsScreen(),
      ),
      GoRoute(
        path: Routes.superDashboard,
        builder: (context, state) => const SuperDashboardScreen(),
      ),
      GoRoute(
        path: Routes.globalSearch,
        builder: (context, state) => const GlobalSearchScreen(),
      ),
      GoRoute(
        path: Routes.globalSearchResults,
        builder: (context, state) => const GlobalSearchResultsScreen(),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.notificationDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return NotificationDetailScreen(notificationId: id);
        },
      ),
      GoRoute(
        path: Routes.scanQr,
        builder: (context, state) => const ScanQrScreen(),
      ),
      GoRoute(
        path: Routes.qrError,
        builder: (context, state) => const QrErrorScreen(),
      ),
      GoRoute(
        path: Routes.deepLinkLoading,
        builder: (context, state) => const DeepLinkLoadingScreen(),
      ),
      GoRoute(
        path: Routes.chatInbox,
        builder: (context, state) => const ChatInboxScreen(),
      ),
      GoRoute(
        path: Routes.chatConversation,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId'] ?? '';
          return ChatConversationScreen(chatId: chatId);
        },
      ),
      GoRoute(
        path: Routes.contacts,
        builder: (context, state) => const ContactsScreen(),
      ),
      GoRoute(
        path: Routes.chatGroup,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId'] ?? '';
          return GroupChatScreen(chatId: chatId);
        },
      ),
      GoRoute(
        path: Routes.chatMedia,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId'] ?? '';
          return MediaGalleryScreen(chatId: chatId);
        },
      ),
      GoRoute(
        path: Routes.callVoice,
        builder: (context, state) {
          final recipientId = state.pathParameters['recipientId'] ?? '';
          return VoiceCallScreen(recipientId: recipientId);
        },
      ),
      GoRoute(
        path: Routes.callVideo,
        builder: (context, state) {
          final recipientId = state.pathParameters['recipientId'] ?? '';
          return VideoCallScreen(recipientId: recipientId);
        },
      ),
      GoRoute(
        path: Routes.callIncoming,
        builder: (context, state) {
          final callerId = state.pathParameters['callerId'] ?? '';
          return IncomingCallScreen(callerId: callerId);
        },
      ),
      GoRoute(
        path: Routes.adminLogin,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: Routes.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: Routes.adminUsers,
        builder: (context, state) => const AdminUsersScreen(),
      ),
      GoRoute(
        path: Routes.adminOrders,
        builder: (context, state) => const AdminOrdersScreen(),
      ),
      GoRoute(
        path: Routes.adminAnalytics,
        builder: (context, state) => const AdminAnalyticsScreen(),
      ),
      GoRoute(
        path: Routes.adminPromotions,
        builder: (context, state) => const AdminPromotionsScreen(),
      ),
      GoRoute(
        path: Routes.adminConfig,
        builder: (context, state) => const AdminConfigScreen(),
      ),
      GoRoute(
        path: Routes.adminReports,
        builder: (context, state) => const AdminReportsScreen(),
      ),
      GoRoute(
        path: Routes.adminNotifications,
        builder: (context, state) => const AdminNotificationScreen(),
      ),
      GoRoute(
        path: Routes.adminSupport,
        builder: (context, state) => const AdminSupportTicketsScreen(),
      ),
      GoRoute(
        path: Routes.adminModeration,
        builder: (context, state) => const AdminContentModerationScreen(),
      ),
      GoRoute(
        path: Routes.driverDashboard,
        builder: (context, state) => const DriverDashboardScreen(),
      ),
      GoRoute(
        path: Routes.driverTrips,
        builder: (context, state) => const DriverTripsScreen(),
      ),
      GoRoute(
        path: Routes.driverEarnings,
        builder: (context, state) => const DriverEarningsScreen(),
      ),
      GoRoute(
        path: Routes.driverPerformance,
        builder: (context, state) => const DriverPerformanceScreen(),
      ),
      GoRoute(
        path: Routes.driverIncentives,
        builder: (context, state) => const DriverIncentivesScreen(),
      ),
      GoRoute(
        path: Routes.driverTraining,
        builder: (context, state) => const DriverTrainingScreen(),
      ),
      GoRoute(
        path: Routes.driverDocuments,
        builder: (context, state) => const DriverDocumentsScreen(),
      ),
      GoRoute(
        path: Routes.driverRegister,
        builder: (context, state) => const DriverRegistrationScreen(),
      ),
      GoRoute(
        path: Routes.analyticsSpending,
        builder: (context, state) => const AnalyticsSpendingScreen(),
      ),
      GoRoute(
        path: Routes.analyticsIncome,
        builder: (context, state) => const AnalyticsIncomeScreen(),
      ),
      GoRoute(
        path: Routes.analyticsBudget,
        builder: (context, state) => const AnalyticsBudgetScreen(),
      ),
      GoRoute(
        path: Routes.analyticsSavings,
        builder: (context, state) => const AnalyticsSavingsScreen(),
      ),
      GoRoute(
        path: Routes.analyticsInvestment,
        builder: (context, state) => const AnalyticsInvestmentScreen(),
      ),
      GoRoute(
        path: Routes.analyticsTax,
        builder: (context, state) => const AnalyticsTaxScreen(),
      ),
      GoRoute(
        path: Routes.analyticsGoals,
        builder: (context, state) => const AnalyticsGoalsScreen(),
      ),
      GoRoute(
        path: Routes.analyticsComparison,
        builder: (context, state) => const AnalyticsComparisonScreen(),
      ),
      GoRoute(
        path: Routes.analyticsCategory,
        builder: (context, state) => const AnalyticsCategoryScreen(),
      ),
      GoRoute(
        path: Routes.analyticsTrends,
        builder: (context, state) => const AnalyticsTrendsScreen(),
      ),
      GoRoute(
        path: Routes.analyticsReports,
        builder: (context, state) => const AnalyticsReportsScreen(),
      ),
      GoRoute(
        path: Routes.marketingSpin,
        builder: (context, state) => const MarketingSpinWheelScreen(),
      ),
      GoRoute(
        path: Routes.marketingScratch,
        builder: (context, state) => const MarketingScratchCardScreen(),
      ),
      GoRoute(
        path: Routes.marketingCheckin,
        builder: (context, state) => const MarketingDailyCheckInScreen(),
      ),
      GoRoute(
        path: Routes.marketingLeaderboard,
        builder: (context, state) => const MarketingLeaderboardScreen(),
      ),
      GoRoute(
        path: Routes.marketingBadges,
        builder: (context, state) => const MarketingBadgesScreen(),
      ),
      GoRoute(
        path: Routes.marketingBanners,
        builder: (context, state) => const MarketingBannersScreen(),
      ),
      GoRoute(
        path: Routes.merchantDashboard,
        builder: (context, state) => const MerchantDashboardScreen(),
      ),
      GoRoute(
        path: Routes.merchantOrders,
        builder: (context, state) => const MerchantOrdersScreen(),
      ),
      GoRoute(
        path: Routes.merchantProducts,
        builder: (context, state) => const MerchantProductsScreen(),
      ),
      GoRoute(
        path: Routes.merchantInventory,
        builder: (context, state) => const MerchantInventoryScreen(),
      ),
      GoRoute(
        path: Routes.merchantPromotions,
        builder: (context, state) => const MerchantPromotionsScreen(),
      ),
      GoRoute(
        path: Routes.merchantPayouts,
        builder: (context, state) => const MerchantPayoutsScreen(),
      ),
      GoRoute(
        path: Routes.merchantReviews,
        builder: (context, state) => const MerchantReviewsScreen(),
      ),
      GoRoute(
        path: Routes.merchantProfile,
        builder: (context, state) => const MerchantProfileScreen(),
      ),
      GoRoute(
        path: Routes.merchantSales,
        builder: (context, state) => const MerchantSalesScreen(),
      ),
      GoRoute(
        path: Routes.merchantRegister,
        builder: (context, state) => const MerchantRegistrationScreen(),
      ),
      GoRoute(
        path: Routes.settingsAccessibility,
        builder: (context, state) => const SettingsAccessibilityScreen(),
      ),
      GoRoute(
        path: Routes.settingsFontSize,
        builder: (context, state) => const SettingsFontSizeScreen(),
      ),
      GoRoute(
        path: Routes.settingsColorBlind,
        builder: (context, state) => const SettingsColorBlindScreen(),
      ),
      GoRoute(
        path: Routes.settingsVoice,
        builder: (context, state) => const SettingsVoiceCommandsScreen(),
      ),
      GoRoute(
        path: Routes.settingsNetwork,
        builder: (context, state) => const SettingsNetworkScreen(),
      ),
      GoRoute(
        path: Routes.settingsStorage,
        builder: (context, state) => const SettingsStorageScreen(),
      ),
      GoRoute(
        path: Routes.settingsOffline,
        builder: (context, state) => const SettingsOfflineModeScreen(),
      ),
      GoRoute(
        path: Routes.socialFriends,
        builder: (context, state) => const SocialFriendsScreen(),
      ),
      GoRoute(
        path: Routes.socialAddFriend,
        builder: (context, state) => const SocialAddFriendScreen(),
      ),
      GoRoute(
        path: Routes.socialProfile,
        builder: (context, state) {
          final userId = state.pathParameters['userId'] ?? '';
          return SocialProfileScreen(userId: userId);
        },
      ),
      GoRoute(
        path: Routes.socialActivity,
        builder: (context, state) => const SocialActivityFeedScreen(),
      ),
      GoRoute(
        path: Routes.socialGift,
        builder: (context, state) => const SocialGiftScreen(),
      ),
      GoRoute(
        path: Routes.socialSplit,
        builder: (context, state) => const SocialSplitExpenseScreen(),
      ),
      GoRoute(
        path: Routes.socialLocation,
        builder: (context, state) => const SocialShareLocationScreen(),
      ),
      GoRoute(
        path: Routes.socialChallenges,
        builder: (context, state) => const SocialChallengesScreen(),
      ),
      GoRoute(
        path: Routes.rideHome,
        builder: (context, state) => const RideHomeScreen(),
      ),
      GoRoute(
        path: Routes.ridePickLocation,
        builder: (context, state) => const RidePickLocationScreen(),
      ),
      GoRoute(
        path: Routes.rideSavedPlaces,
        builder: (context, state) => const RideSavedPlacesScreen(),
      ),
      GoRoute(
        path: Routes.rideSelectVehicle,
        builder: (context, state) => const RideSelectVehicleScreen(),
      ),
      GoRoute(
        path: Routes.ridePriceEstimate,
        builder: (context, state) => const RidePriceEstimateScreen(),
      ),
      GoRoute(
        path: Routes.rideFindingDriver,
        builder: (context, state) => const RideFindingDriverScreen(),
      ),
      GoRoute(
        path: Routes.rideDriverFound,
        builder: (context, state) => const RideDriverFoundScreen(),
      ),
      GoRoute(
        path: Routes.rideInProgress,
        builder: (context, state) => const RideInProgressScreen(),
      ),
      GoRoute(
        path: Routes.rideCompleted,
        builder: (context, state) => const RideCompletedScreen(),
      ),
      GoRoute(
        path: Routes.rideReceipt,
        builder: (context, state) => const RideReceiptScreen(),
      ),
      GoRoute(
        path: Routes.rideRateDriver,
        builder: (context, state) => const RideRateDriverScreen(),
      ),
      GoRoute(
        path: Routes.rideMessageDriver,
        builder: (context, state) => const RideMessageDriverScreen(),
      ),
      GoRoute(
        path: Routes.rideCallDriver,
        builder: (context, state) => const RideCallDriverScreen(),
      ),
      GoRoute(
        path: Routes.rideHistory,
        builder: (context, state) => const RideHistoryScreen(),
      ),
      GoRoute(
        path: Routes.rideSchedule,
        builder: (context, state) => const RideScheduleScreen(),
      ),
      GoRoute(
        path: Routes.rideAddPayment,
        builder: (context, state) => const RideAddPaymentScreen(),
      ),
      GoRoute(
        path: Routes.ridePaymentMethod,
        builder: (context, state) => const RidePaymentMethodScreen(),
      ),
      GoRoute(
        path: Routes.rideEmergency,
        builder: (context, state) => const RideEmergencyScreen(),
      ),
      GoRoute(
        path: Routes.rideShare,
        builder: (context, state) => const RideShareScreen(),
      ),
      GoRoute(
        path: Routes.ridePass,
        builder: (context, state) => const RidePassScreen(),
      ),
      GoRoute(
        path: Routes.rideRental,
        builder: (context, state) => const RideRentalScreen(),
      ),
      GoRoute(
        path: Routes.rideInsurance,
        builder: (context, state) => const RideInsuranceScreen(),
      ),
      GoRoute(
        path: Routes.rideDriverEarnings,
        builder: (context, state) => const RideDriverEarningsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.martHome,
                builder: (context, state) => const MartHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => const MartSearchScreen(),
                  ),
                  GoRoute(
                    path: 'products',
                    builder: (context, state) => const MartProductsScreen(),
                  ),
                  GoRoute(
                    path: 'categories',
                    builder: (context, state) => const MartCategoriesScreen(),
                  ),
                  GoRoute(
                    path: 'flashSale',
                    builder: (context, state) => const MartFlashSaleScreen(),
                  ),
                  GoRoute(
                    path: 'product/:id',
                    builder: (context, state) {
                      final id =
                          int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                      return MartProductDetailScreen(productId: id);
                    },
                  ),
                  GoRoute(
                    path: 'product/:id/reviews',
                    builder: (context, state) {
                      final id =
                          int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                      return MartProductReviewsScreen(productId: id);
                    },
                  ),
                  GoRoute(
                    path: 'seller/:sellerId',
                    builder: (context, state) {
                      final sellerId = state.pathParameters['sellerId'] ?? '';
                      return MartSellerProfileScreen(sellerId: sellerId);
                    },
                  ),
                  GoRoute(
                    path: 'cart',
                    builder: (context, state) => const MartCartScreen(),
                  ),
                  GoRoute(
                    path: 'checkout',
                    builder: (context, state) => const MartCheckoutScreen(),
                  ),
                  GoRoute(
                    path: 'orderPlaced',
                    builder: (context, state) => const MartOrderPlacedScreen(),
                  ),
                  GoRoute(
                    path: 'orders',
                    builder: (context, state) => const MartOrdersScreen(),
                  ),
                  GoRoute(
                    path: 'orders/:orderId/tracking',
                    builder: (context, state) =>
                        const MartOrderTrackingScreen(),
                  ),
                  GoRoute(
                    path: 'orders/:orderId/return',
                    builder: (context, state) =>
                        const MartReturnRequestScreen(),
                  ),
                  GoRoute(
                    path: 'returnSubmitted',
                    builder: (context, state) =>
                        const MartReturnSubmittedScreen(),
                  ),
                  GoRoute(
                    path: 'wishlist',
                    builder: (context, state) => const MartWishlistScreen(),
                  ),
                  GoRoute(
                    path: 'compare',
                    builder: (context, state) => const MartCompareScreen(),
                  ),
                  GoRoute(
                    path: 'deals',
                    builder: (context, state) => const MartDealsScreen(),
                  ),
                  GoRoute(
                    path: 'brands',
                    builder: (context, state) => const MartBrandsScreen(),
                  ),
                  GoRoute(
                    path: 'coupons',
                    builder: (context, state) => const MartCouponsScreen(),
                  ),
                  GoRoute(
                    path: 'auction',
                    builder: (context, state) => const MartAuctionScreen(),
                  ),
                  GoRoute(
                    path: 'giftCards',
                    builder: (context, state) => const MartGiftCardsScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.foodHome,
                builder: (context, state) => const FoodHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'category/:category',
                    builder: (context, state) {
                      final category = state.pathParameters['category'] ?? '';
                      return FoodCategoryFilterScreen(category: category);
                    },
                  ),
                  GoRoute(
                    path: 'restaurants',
                    builder: (context, state) =>
                        const FoodRestaurantListScreen(),
                  ),
                  GoRoute(
                    path: 'restaurantSearch',
                    builder: (context, state) =>
                        const FoodRestaurantSearchScreen(),
                  ),
                  GoRoute(
                    path: 'restaurant/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return FoodRestaurantDetailScreen(restaurantId: id);
                    },
                  ),
                  GoRoute(
                    path: 'restaurant/:id/info',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return FoodRestaurantInfoScreen(restaurantId: id);
                    },
                  ),
                  GoRoute(
                    path: 'item/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return FoodItemDetailScreen(itemId: id);
                    },
                  ),
                  GoRoute(
                    path: 'item/:id/customize',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return FoodCustomizeItemScreen(itemId: id);
                    },
                  ),
                  GoRoute(
                    path: 'cart',
                    builder: (context, state) => const FoodCartScreen(),
                  ),
                  GoRoute(
                    path: 'cartEmpty',
                    builder: (context, state) => const FoodCartEmptyScreen(),
                  ),
                  GoRoute(
                    path: 'checkout/address',
                    builder: (context, state) =>
                        const FoodCheckoutAddressScreen(),
                  ),
                  GoRoute(
                    path: 'checkout/promo',
                    builder: (context, state) =>
                        const FoodCheckoutPromoScreen(),
                  ),
                  GoRoute(
                    path: 'checkout/note',
                    builder: (context, state) => const FoodCheckoutNoteScreen(),
                  ),
                  GoRoute(
                    path: 'checkout/payment',
                    builder: (context, state) =>
                        const FoodCheckoutPaymentScreen(),
                  ),
                  GoRoute(
                    path: 'paymentProcessing',
                    builder: (context, state) =>
                        const FoodPaymentProcessingScreen(),
                  ),
                  GoRoute(
                    path: 'orderPlaced',
                    builder: (context, state) => const FoodOrderPlacedScreen(),
                  ),
                  GoRoute(
                    path: 'tracking/:orderId/findingDriver',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId'] ?? '';
                      return FoodTrackingFindingDriverScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'tracking/:orderId/preparing',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId'] ?? '';
                      return FoodTrackingPreparingScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'tracking/:orderId/pickedUp',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId'] ?? '';
                      return FoodTrackingPickedUpScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'tracking/:orderId/arrived',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId'] ?? '';
                      return FoodTrackingArrivedScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'order/:orderId/messageDriver',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId'] ?? '';
                      return FoodMessageDriverScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'order/:orderId/callDriver',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId'] ?? '';
                      return FoodCallDriverScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'order/:orderId/complete',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId'] ?? '';
                      return FoodOrderCompleteScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'order/:orderId/rateFood',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId'] ?? '';
                      return FoodRateFoodScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'order/:orderId/rateDriver',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId'] ?? '';
                      return FoodRateDriverScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'orders',
                    builder: (context, state) => const FoodOrderHistoryScreen(),
                  ),
                  GoRoute(
                    path: 'orders/:orderId',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId'] ?? '';
                      return FoodOrderDetailScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'favorites',
                    builder: (context, state) => const FoodFavoritesScreen(),
                  ),
                  GoRoute(
                    path: 'allergies',
                    builder: (context, state) => const FoodAllergiesScreen(),
                  ),
                  GoRoute(
                    path: 'nutrition/:itemId',
                    builder: (context, state) {
                      final itemId = state.pathParameters['itemId'] ?? '';
                      return FoodNutritionScreen(itemId: itemId);
                    },
                  ),
                  GoRoute(
                    path: 'groupOrder',
                    builder: (context, state) => const FoodGroupOrderScreen(),
                  ),
                  GoRoute(
                    path: 'tableBooking',
                    builder: (context, state) => const FoodTableBookingScreen(),
                  ),
                  GoRoute(
                    path: 'reservations',
                    builder: (context, state) =>
                        const FoodReservationHistoryScreen(),
                  ),
                  GoRoute(
                    path: 'loyalty',
                    builder: (context, state) => const FoodLoyaltyScreen(),
                  ),
                  GoRoute(
                    path: 'promocode',
                    builder: (context, state) => const FoodPromocodeScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.walletHome,
                builder: (context, state) => const WalletHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'card/:id',
                    builder: (context, state) => const WalletCardDetailScreen(),
                  ),
                  GoRoute(
                    path: 'cards',
                    builder: (context, state) => const WalletCardsScreen(),
                  ),
                  GoRoute(
                    path: 'addCard',
                    builder: (context, state) => const WalletAddCardScreen(),
                  ),
                  GoRoute(
                    path: 'transactions',
                    builder: (context, state) =>
                        const WalletTransactionsScreen(),
                  ),
                  GoRoute(
                    path: 'send',
                    builder: (context, state) => const WalletSendScreen(),
                  ),
                  GoRoute(
                    path: 'send/confirm',
                    builder: (context, state) => const WalletSendConfirmScreen(
                      recipientName: '',
                      recipientEmail: '',
                      amount: 0,
                    ),
                  ),
                  GoRoute(
                    path: 'send/success',
                    builder: (context, state) => const WalletSendSuccessScreen(
                      recipientName: '',
                      amount: 0,
                      transactionId: '',
                    ),
                  ),
                  GoRoute(
                    path: 'request',
                    builder: (context, state) => const WalletRequestScreen(),
                  ),
                  GoRoute(
                    path: 'request/sent',
                    builder: (context, state) => const WalletRequestSentScreen(
                      recipientName: '',
                      amount: 0,
                    ),
                  ),
                  GoRoute(
                    path: 'topUp',
                    builder: (context, state) => const WalletTopUpScreen(),
                  ),
                  GoRoute(
                    path: 'topUp/confirm',
                    builder: (context, state) =>
                        const WalletTopUpConfirmScreen(amount: 0, method: ''),
                  ),
                  GoRoute(
                    path: 'topUp/success',
                    builder: (context, state) => const WalletTopUpSuccessScreen(
                      amount: 0,
                      newBalance: 0,
                      method: '',
                      transactionId: '',
                    ),
                  ),
                  GoRoute(
                    path: 'scan',
                    builder: (context, state) => const WalletScanScreen(),
                  ),
                  GoRoute(
                    path: 'myQr',
                    builder: (context, state) => const WalletMyQrScreen(),
                  ),
                  GoRoute(
                    path: 'billPayment',
                    builder: (context, state) =>
                        const WalletBillPaymentsScreen(),
                  ),
                  GoRoute(
                    path: 'payBill',
                    builder: (context, state) => const WalletPayBillScreen(),
                  ),
                  GoRoute(
                    path: 'linkedBanks',
                    builder: (context, state) =>
                        const WalletBankAccountsScreen(),
                  ),
                  GoRoute(
                    path: 'withdraw',
                    builder: (context, state) => const WalletWithdrawScreen(),
                  ),
                  GoRoute(
                    path: 'budget',
                    builder: (context, state) => const WalletBudgetScreen(),
                  ),
                  GoRoute(
                    path: 'analytics',
                    builder: (context, state) => const WalletAnalyticsScreen(),
                  ),
                  GoRoute(
                    path: 'invest',
                    builder: (context, state) => const WalletInvestScreen(),
                  ),
                  GoRoute(
                    path: 'loan',
                    builder: (context, state) => const WalletLoanScreen(),
                  ),
                  GoRoute(
                    path: 'cashback',
                    builder: (context, state) => const WalletCashbackScreen(),
                  ),
                  GoRoute(
                    path: 'splitBill',
                    builder: (context, state) => const WalletSplitBillScreen(),
                  ),
                  GoRoute(
                    path: 'recurring',
                    builder: (context, state) =>
                        const WalletRecurringPaymentsScreen(),
                  ),
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
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => const ServicesSearchScreen(),
                  ),
                  GoRoute(
                    path: 'providers',
                    builder: (context, state) =>
                        const ServicesProvidersScreen(),
                  ),
                  GoRoute(
                    path: 'provider/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return ServicesProviderProfileScreen(providerId: id);
                    },
                  ),
                  GoRoute(
                    path: 'booking',
                    builder: (context, state) => const ServicesBookingScreen(),
                  ),
                  GoRoute(
                    path: 'booking/confirmed',
                    builder: (context, state) =>
                        const ServicesBookingConfirmedScreen(),
                  ),
                  GoRoute(
                    path: 'tracking',
                    builder: (context, state) => const ServicesTrackingScreen(),
                  ),
                  GoRoute(
                    path: 'chat',
                    builder: (context, state) => const ServicesChatScreen(),
                  ),
                  GoRoute(
                    path: 'history',
                    builder: (context, state) => const ServicesHistoryScreen(),
                  ),
                  GoRoute(
                    path: 'rate',
                    builder: (context, state) => const ServicesRateScreen(),
                  ),
                  GoRoute(
                    path: 'promo',
                    builder: (context, state) => const ServicesPromoScreen(),
                  ),
                  GoRoute(
                    path: 'subscription',
                    builder: (context, state) =>
                        const ServicesSubscriptionScreen(),
                  ),
                  GoRoute(
                    path: 'warranty',
                    builder: (context, state) => const ServicesWarrantyScreen(),
                  ),
                  GoRoute(
                    path: 'insurance',
                    builder: (context, state) =>
                        const ServicesInsuranceScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profileHome,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const ProfileEditScreen(),
                  ),
                  GoRoute(
                    path: 'qr',
                    builder: (context, state) => const ProfileQrScreen(),
                  ),
                  GoRoute(
                    path: 'security',
                    builder: (context, state) => const ProfileSecurityScreen(),
                  ),
                  GoRoute(
                    path: 'activity',
                    builder: (context, state) => const ProfileActivityScreen(),
                  ),
                  GoRoute(
                    path: 'membership',
                    builder: (context, state) => const MembershipScreen(),
                  ),
                  GoRoute(
                    path: 'addresses',
                    builder: (context, state) => const AddressesScreen(),
                  ),
                  GoRoute(
                    path: 'addresses/add',
                    builder: (context, state) => const AddressAddScreen(),
                  ),
                  GoRoute(
                    path: 'paymentMethods',
                    builder: (context, state) => const PaymentMethodsScreen(),
                  ),
                  GoRoute(
                    path: 'language',
                    builder: (context, state) => const LanguageScreen(),
                  ),
                  GoRoute(
                    path: 'theme',
                    builder: (context, state) => const ThemeScreen(),
                  ),
                  GoRoute(
                    path: 'notificationSettings',
                    builder: (context, state) =>
                        const NotificationSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'privacy',
                    builder: (context, state) => const PrivacySettingsScreen(),
                  ),
                  GoRoute(
                    path: 'helpCenter',
                    builder: (context, state) => const HelpCenterScreen(),
                  ),
                  GoRoute(
                    path: 'supportChat',
                    builder: (context, state) => const SupportChatScreen(),
                  ),
                  GoRoute(
                    path: 'supportEmail',
                    builder: (context, state) => const SupportEmailScreen(),
                  ),
                  GoRoute(
                    path: 'supportTicket',
                    builder: (context, state) => const SupportTicketScreen(),
                  ),
                  GoRoute(
                    path: 'about',
                    builder: (context, state) => const AboutScreen(),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                  GoRoute(
                    path: 'referral',
                    builder: (context, state) => const ReferralScreen(),
                  ),
                  GoRoute(
                    path: 'feedback',
                    builder: (context, state) => const FeedbackScreen(),
                  ),
                  GoRoute(
                    path: 'dataUsage',
                    builder: (context, state) => const DataUsageScreen(),
                  ),
                ],
              ),
            ],
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
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Mart',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant),
            label: 'Food',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.handyman_outlined),
            selectedIcon: Icon(Icons.handyman),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}