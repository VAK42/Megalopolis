import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../mart/constants/martConstants.dart';
class MartOrderTrackingScreen extends StatelessWidget {
 const MartOrderTrackingScreen({super.key});
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(MartConstants.trackOrderTitle),
   ),
   body: Column(
    children: [
     Expanded(
      child: Center(child: Icon(Icons.map, size: 100, color: Colors.grey[300])),
     ),
     Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
       color: Colors.white,
       boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5))],
       borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        const Text(MartConstants.orderStatus, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildStep(MartConstants.orderPlacedMessage, '3:45 PM', true, true),
        _buildStep(MartConstants.orderConfirmed, '3:50 PM', true, true),
        _buildStep(MartConstants.onTheWay, '4:15 PM', true, false),
        _buildStep(MartConstants.delivered, 'Estimated 4:30 PM', false, false),
       ],
      ),
     ),
    ],
   ),
  );
 }
 Widget _buildStep(String title, String time, bool isActive, bool isCompleted) {
  return Row(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Column(
     children: [
      Container(
       width: 24,
       height: 24,
       decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey[300],
        shape: BoxShape.circle,
        border: isCompleted ? null : Border.all(color: AppColors.primary, width: 2),
       ),
       child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
      ),
      if (title != MartConstants.delivered) Container(width: 2, height: 40, color: isCompleted ? AppColors.primary : Colors.grey[300]),
     ],
    ),
    const SizedBox(width: 16),
    Expanded(
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isActive ? Colors.black : Colors.grey),
       ),
       Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
       const SizedBox(height: 24),
      ],
     ),
    ),
   ],
  );
 }
}