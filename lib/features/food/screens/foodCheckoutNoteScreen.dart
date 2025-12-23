import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/foodConstants.dart';
class FoodCheckoutNoteScreen extends ConsumerStatefulWidget {
 const FoodCheckoutNoteScreen({super.key});
 @override
 ConsumerState<FoodCheckoutNoteScreen> createState() => _FoodCheckoutNoteScreenState();
}
class _FoodCheckoutNoteScreenState extends ConsumerState<FoodCheckoutNoteScreen> {
 final noteController = TextEditingController();
 @override
 void dispose() {
  noteController.dispose();
  super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(FoodConstants.checkoutNoteTitle),
   ),
   body: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
     children: [
      TextField(
       controller: noteController,
       maxLines: 5,
       decoration: InputDecoration(
        hintText: FoodConstants.noteHint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),
      const SizedBox(height: 16),
      SizedBox(
       width: double.infinity,
       child: ElevatedButton(
        onPressed: () => context.pop(),
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
        child: const Text(FoodConstants.saveNote),
       ),
      ),
     ],
    ),
   ),
  );
 }
}