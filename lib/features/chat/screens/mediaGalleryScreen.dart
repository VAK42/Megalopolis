import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/chatProvider.dart';
import '../../chat/constants/chatConstants.dart';
class MediaGalleryScreen extends ConsumerStatefulWidget {
 final String chatId;
 const MediaGalleryScreen({super.key, required this.chatId});
 @override
 ConsumerState<MediaGalleryScreen> createState() => _MediaGalleryScreenState();
}
class _MediaGalleryScreenState extends ConsumerState<MediaGalleryScreen> with SingleTickerProviderStateMixin {
 late TabController tabController;
 @override
 void initState() {
  super.initState();
  tabController = TabController(length: 3, vsync: this);
 }
 @override
 void dispose() {
  tabController.dispose();
  super.dispose();
 }
 @override
 Widget build(BuildContext context) {
  final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));
  return Scaffold(
   appBar: AppBar(
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
    title: const Text(ChatConstants.mediaTitle),
    bottom: TabBar(
     controller: tabController,
     tabs: const [
      Tab(text: ChatConstants.photosTab),
      Tab(text: ChatConstants.videosTab),
      Tab(text: ChatConstants.linksTab),
     ],
    ),
   ),
   body: messagesAsync.when(
    data: (messages) {
     final photos = messages.where((m) => m['type'] == 'image').toList();
     final videos = messages.where((m) => m['type'] == 'video').toList();
     final links = messages.where((m) => (m['content'] as String?)?.startsWith('http') ?? false).toList();
     return TabBarView(controller: tabController, children: [_buildPhotosGrid(photos), _buildVideosGrid(videos), _buildLinksList(links)]);
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, _) => Center(child: Text('${ChatConstants.errorPrefix}$e')),
   ),
  );
 }
 Widget _buildPhotosGrid(List<Map<String, dynamic>> photos) {
  if (photos.isEmpty) {
   return const Center(child: Text(ChatConstants.noPhotos));
  }
  return GridView.builder(
   padding: const EdgeInsets.all(4),
   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
   itemCount: photos.length,
   itemBuilder: (context, index) => Container(
    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
    child: const Icon(Icons.image, color: AppColors.primary),
   ),
  );
 }
 Widget _buildVideosGrid(List<Map<String, dynamic>> videos) {
  if (videos.isEmpty) {
   return const Center(child: Text(ChatConstants.noVideos));
  }
  return GridView.builder(
   padding: const EdgeInsets.all(4),
   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 16 / 9, crossAxisSpacing: 4, mainAxisSpacing: 4),
   itemCount: videos.length,
   itemBuilder: (context, index) => Container(
    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
    child: const Center(child: Icon(Icons.play_circle, color: Colors.white, size: 48)),
   ),
  );
 }
 Widget _buildLinksList(List<Map<String, dynamic>> links) {
  if (links.isEmpty) {
   return const Center(child: Text(ChatConstants.noLinks));
  }
  return ListView.builder(
   padding: const EdgeInsets.all(16),
   itemCount: links.length,
   itemBuilder: (context, index) {
    final link = links[index];
    return Card(
     margin: const EdgeInsets.only(bottom: 8),
     child: ListTile(
      leading: const Icon(Icons.link, color: AppColors.primary),
      title: Text(link['content']?.toString() ?? ChatConstants.linkPlaceholder, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.open_in_new, size: 20),
     ),
    );
   },
  );
 }
}