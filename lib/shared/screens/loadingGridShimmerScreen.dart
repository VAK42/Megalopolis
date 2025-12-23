import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class LoadingGridShimmerScreen extends ConsumerWidget {
 const LoadingGridShimmerScreen({super.key});
 @override
 Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
   appBar: AppBar(title: const Text('Loading...')),
   body: GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.7), itemCount: 6, itemBuilder: (context, index) => _buildShimmerCard()),
  );
 }
 Widget _buildShimmerCard() {
  return Container(
   decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
   ),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     _buildShimmerBox(double.infinity, 140, const BorderRadius.vertical(top: Radius.circular(12))),
     Padding(
      padding: const EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildShimmerBox(double.infinity, 16, BorderRadius.circular(4)), const SizedBox(height: 8), _buildShimmerBox(80, 12, BorderRadius.circular(4)), const SizedBox(height: 8), _buildShimmerBox(60, 16, BorderRadius.circular(4))]),
     ),
    ],
   ),
  );
 }
 Widget _buildShimmerBox(double width, double height, BorderRadius radius) {
  return Container(
   width: width,
   height: height,
   decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: radius),
  );
 }
}