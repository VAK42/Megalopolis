import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class LoadingShimmerScreen extends ConsumerWidget {
  const LoadingShimmerScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading...')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => _buildShimmerCard(),
      ),
    );
  }
  Widget _buildShimmerCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildShimmerBox(60, 60, 8),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerBox(double.infinity, 16, 4),
                  const SizedBox(height: 8),
                  _buildShimmerBox(150, 12, 4),
                  const SizedBox(height: 8),
                  _buildShimmerBox(100, 12, 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildShimmerBox(double width, double height, double radius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}