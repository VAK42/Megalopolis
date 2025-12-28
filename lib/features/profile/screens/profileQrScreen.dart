import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/authProvider.dart';
import '../constants/profileConstants.dart';
class ProfileQrScreen extends ConsumerWidget {
 const ProfileQrScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final userAsync = ref.watch(authProvider);
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ProfileConstants.myQrCode),
    actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {})],
   ),
   body: Center(
    child: Padding(
     padding: const EdgeInsets.all(24),
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        userAsync.when(
         data: (user) => Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
           gradient: AppColors.primaryGradient,
           shape: BoxShape.circle,
           image: user?.avatar != null && user!.avatar!.isNotEmpty
               ? DecorationImage(image: NetworkImage(user.avatar!), fit: BoxFit.cover)
               : null,
          ),
          child: user?.avatar == null || user!.avatar!.isEmpty
              ? const Icon(Icons.person, color: Colors.white, size: 50)
              : null,
         ),
         loading: () => Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
          child: const Icon(Icons.person, color: Colors.white, size: 50),
         ),
         error: (_, __) => Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
          child: const Icon(Icons.person, color: Colors.white, size: 50),
         ),
        ),
       const SizedBox(height: 16),
       userAsync.when(
        data: (user) => Column(
         children: [
          Text(user?.name ?? ProfileConstants.guestUser, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(user?.phone ?? user?.email ?? '', style: const TextStyle(color: Colors.grey)),
         ],
        ),
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => const Text(ProfileConstants.error, style: TextStyle(color: Colors.grey)),
       ),
       const SizedBox(height: 32),
       Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(16),
         boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
         children: [
          Container(
           width: 250,
           height: 250,
           decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
           child: Icon(Icons.qr_code, size: 200, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          const Text(ProfileConstants.scanToConnect, style: TextStyle(color: Colors.grey)),
         ],
        ),
       ),
       const SizedBox(height: 32),
       userAsync.when(
        data: (user) => Text(
         '#${user?.id ?? "GUEST"}',
         style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        loading: () => const SizedBox(),
        error: (_, __) => const SizedBox(),
       ),
      ],
     ),
    ),
   ),
  );
 }
}