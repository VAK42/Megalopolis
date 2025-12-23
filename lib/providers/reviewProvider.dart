import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/reviewRepository.dart';
class Review {
 final String id;
 final String targetType;
 final String targetId;
 final String userId;
 final double rating;
 final String? comment;
 final List<String>? images;
 final int createdAt;
 final String? userName;
 final String? userAvatar;
 Review({required this.id, required this.targetType, required this.targetId, required this.userId, required this.rating, this.comment, this.images, required this.createdAt, this.userName, this.userAvatar});
 factory Review.fromMap(Map<String, dynamic> map) {
  return Review(id: map['id'] as String, targetType: map['targetType'] as String, targetId: map['targetId'] as String, userId: map['userId'] as String, rating: (map['rating'] as num).toDouble(), comment: map['comment'] as String?, images: map['images'] != null ? (map['images'] as String).split(',') : null, createdAt: map['createdAt'] as int, userName: map['userName'] as String?, userAvatar: map['userAvatar'] as String?);
 }
}
class ReviewNotifier extends FamilyAsyncNotifier<List<Review>, Map<String, String>> {
 late final ReviewRepository _repository;
 late final String _targetType;
 late final String _targetId;
 @override
 Future<List<Review>> build(Map<String, String> arg) async {
  _repository = ReviewRepository();
  _targetType = arg['targetType']!;
  _targetId = arg['targetId']!;
  return _loadReviews();
 }
 Future<List<Review>> _loadReviews() async {
  final reviewsData = await _repository.getReviews(_targetType, _targetId);
  return reviewsData.map((data) => Review.fromMap(data)).toList();
 }
 Future<void> addReview({required String userId, required double rating, String? comment, List<String>? images}) async {
  try {
   await _repository.addReview(targetType: _targetType, targetId: _targetId, userId: userId, rating: rating, comment: comment, images: images);
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() => _loadReviews());
  } catch (e, stack) {
   state = AsyncValue.error(e, stack);
  }
 }
 Future<double> getAverageRating() async {
  try {
   return await _repository.getAverageRating(_targetType, _targetId);
  } catch (e) {
   return 0.0;
  }
 }
 Future<int> getReviewCount() async {
  try {
   return await _repository.getReviewCount(_targetType, _targetId);
  } catch (e) {
   return 0;
  }
 }
}
final reviewProvider = AsyncNotifierProvider.family<ReviewNotifier, List<Review>, Map<String, String>>(() {
 return ReviewNotifier();
});