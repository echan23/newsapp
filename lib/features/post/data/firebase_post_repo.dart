import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsapp2/features/post/domain/entities/post.dart';
import 'package:newsapp2/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Store posts in collection called 'pposts'
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      //Retreive posts with most recent at the top
      final postsSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      //Convert each firestore document from json to the list of posts
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allPosts;
    } catch (e) {
      throw Exception("Error fetching post: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      final postsSnapshot =
          await postsCollection.where('userId', isEqualTo: userId).get();

      //Convert documents from json to list of posts
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPosts;
    } catch (e) {
      throw Exception("Error: Couldn't fetch posts from user $e");
    }
  }
}
