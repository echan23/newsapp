import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikeStorageService {
  static const String _likeKeyPrefix = 'post_like_';
  static const String _likedPostsKey = 'liked_posts_';

  // Get the current user's UID (for user-specific likes)
  String? _getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Get the current like count for a post
  Future<int> getLikeCount(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_likeKeyPrefix$postId') ?? 0;
  }

  // Check if the current user has liked a specific post
  Future<bool> hasLikedPost(String postId) async {
    final userId = _getUserId();
    if (userId == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final likedPosts = prefs.getStringList('$_likedPostsKey$userId') ?? [];
    return likedPosts.contains(postId);
  }

  // Increment the like count and mark the post as liked
  Future<void> likePost(String postId) async {
    final userId = _getUserId();
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();

    // Increment the like count
    int currentCount = await getLikeCount(postId);
    await prefs.setInt('$_likeKeyPrefix$postId', currentCount + 1);

    // Mark the post as liked by the user
    List<String> likedPosts =
        prefs.getStringList('$_likedPostsKey$userId') ?? [];
    likedPosts.add(postId);
    await prefs.setStringList('$_likedPostsKey$userId', likedPosts);
  }

  // Decrement the like count and unmark the post as liked
  Future<void> unlikePost(String postId) async {
    final userId = _getUserId();
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();

    // Decrement the like count if greater than 0
    int currentCount = await getLikeCount(postId);
    if (currentCount > 0) {
      await prefs.setInt('$_likeKeyPrefix$postId', currentCount - 1);
    }

    // Remove the post from the user's liked posts
    List<String> likedPosts =
        prefs.getStringList('$_likedPostsKey$userId') ?? [];
    likedPosts.remove(postId);
    await prefs.setStringList('$_likedPostsKey$userId', likedPosts);
  }
}
