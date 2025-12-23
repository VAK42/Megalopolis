import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/routeNames.dart';
import '../../../shared/widgets/appButton.dart';
import '../../../shared/widgets/appTextField.dart';
import '../../../providers/serviceProvider.dart';
import '../constants/servicesConstants.dart';
class ServicesRateScreen extends ConsumerStatefulWidget {
 final String? bookingId;
 const ServicesRateScreen({super.key, this.bookingId});
 @override
 ConsumerState<ServicesRateScreen> createState() => _ServicesRateScreenState();
}
class _ServicesRateScreenState extends ConsumerState<ServicesRateScreen> {
 int _rating = 5;
 final reviewController = TextEditingController();
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
    title: const Text(ServicesConstants.rateService),
   ),
   body: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
     children: [
      const SizedBox(height: 32),
      const Icon(Icons.cleaning_services, size: 80, color: AppColors.primary),
      const SizedBox(height: 24),
      const Text(ServicesConstants.howWasService, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: List.generate(5, (index) {
        return IconButton(
         onPressed: () => setState(() => _rating = index + 1),
         icon: Icon(index < _rating ? Icons.star : Icons.star_border, size: 40, color: Colors.amber),
        );
       }),
      ),
      const SizedBox(height: 32),
      AppTextField(controller: reviewController, hint: ServicesConstants.reviewPlaceholder, maxLines: 4),
      const Spacer(),
      AppButton(
       text: ServicesConstants.submitRating,
       onPressed: () async {
        if (widget.bookingId != null) {
         await ref.read(serviceRepositoryProvider).rateService(widget.bookingId!, _rating, reviewController.text);
        }
        if (mounted) context.go(Routes.servicesHome);
       },
       icon: Icons.check,
      ),
     ],
    ),
   ),
  );
 }
}