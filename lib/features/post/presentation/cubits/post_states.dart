/*
Post states
*/

import 'package:newsapp2/features/post/domain/entities/post.dart';

abstract class PostState {}

// Initial state
class PostsInitial extends PostState {}

// Loading state
class PostsLoading extends PostState {}

// Uploading
class PostsUploading extends PostState {}

// Loaded state with post data
class PostsLoaded extends PostState {
  final List<Post> posts; // List of posts fetched from the database
  PostsLoaded(this.posts);
}

// Error state with an error message
class PostsError extends PostState {
  final String message;
  PostsError(this.message);
}
