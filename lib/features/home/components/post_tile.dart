import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp2/features/post/domain/entities/post.dart';
import 'package:newsapp2/features/storage/data/like_storage_service.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final LikeStorageService likeStorageService;
  final VoidCallback onDelete;

  const PostTile({
    super.key,
    required this.post,
    required this.likeStorageService,
    required this.onDelete,
  });

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  bool hasLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeLikeState();
  }

  // Initialize like state from SharedPreferences
  Future<void> _initializeLikeState() async {
    hasLiked = await widget.likeStorageService.hasLikedPost(widget.post.id);
    likeCount = await widget.likeStorageService.getLikeCount(widget.post.id);
    setState(() {});
  }

  // Toggle like/unlike and refresh UI
  Future<void> _toggleLike() async {
    if (hasLiked) {
      await widget.likeStorageService.unlikePost(widget.post.id);
    } else {
      await widget.likeStorageService.likePost(widget.post.id);
    }
    await _initializeLikeState(); // Refresh like state
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header: Name and Timestamp
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.post.userName ?? 'Anonymous',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatTimestamp(widget.post.timestamp),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Display Image or Placeholder
          widget.post.imageURL != null
              ? CachedNetworkImage(
                  imageUrl: widget.post.imageURL!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.red,
                  ),
                )
              : const SizedBox(
                  height: 250,
                  child: Center(
                    child: Text('No Image Available',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),

          const SizedBox(height: 8),

          // Post Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              widget.post.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Like and Delete Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Like Button with Count
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: hasLiked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: _toggleLike,
                    ),
                    Text('$likeCount'),
                  ],
                ),
                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format the timestamp
  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} "
        "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  }
}
