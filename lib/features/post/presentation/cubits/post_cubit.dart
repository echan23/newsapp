import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp2/features/post/domain/entities/post.dart';
import 'package:newsapp2/features/post/domain/repos/post_repo.dart';
import 'package:newsapp2/features/post/presentation/cubits/post_states.dart';
import 'package:newsapp2/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostsInitial());

  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    try {
      String? imageURL;
      // If an image is provided, upload it to storage
      if (imagePath != null) {
        emit(PostsUploading());
        imageURL = await storageRepo.uploadPostImageMobile(imagePath, post.id);

        // Proceed with the rest of your logic (e.g., saving post data)
      } else if (imageBytes != null) {
        emit(PostsUploading());
        imageURL = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      // Create the post with the image URL (if available)
      final newPost = post.copyWith(imageURL: imageURL);
      postRepo.createPost(newPost);

      //Fetch all posts
      fetchAllPosts();
    } catch (e) {
      emit(PostsError('Failed to create post: ${e.toString()}'));
    }
  }

  //fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError('Failed to ftch posts: $e'));
    }
  }

  //Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {}
  }
}
