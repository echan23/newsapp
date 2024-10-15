import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp2/components/my_drawer.dart';
import 'package:newsapp2/features/home/components/post_tile.dart';
import 'package:newsapp2/features/post/domain/entities/post.dart';
import 'package:newsapp2/features/post/presentation/cubits/post_cubit.dart';
import 'package:newsapp2/features/post/presentation/cubits/post_states.dart';
import 'package:newsapp2/features/post/presentation/pages/upload_post_page.dart';
import 'package:newsapp2/features/storage/data/like_storage_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController newPostController = TextEditingController();
  late final PostCubit postCubit;
  final LikeStorageService likeStorageService = LikeStorageService();

  @override
  void initState() {
    super.initState();
    postCubit = context.read<PostCubit>();
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts(); // Refresh posts after deletion
  }

  void toggleLike(Post post) async {
    final hasLiked = await likeStorageService.hasLikedPost(post.id);
    if (hasLiked) {
      await likeStorageService.unlikePost(post.id);
    } else {
      await likeStorageService.likePost(post.id);
    }
    setState(() {}); // Refresh the UI after like/unlike
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Feed"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UploadPostPage()),
              );
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostsLoaded) {
            final allPosts = state.posts;
            if (allPosts.isEmpty) {
              return const Center(child: Text("No posts available"));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                final post = allPosts[index];
                return PostTile(
                  post: post,
                  likeStorageService: likeStorageService,
                  onDelete: () => deletePost(post.id),
                );
              },
            );
          } else if (state is PostsError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else {
            return const Center(child: Text("Unexpected error occurred"));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    newPostController.dispose();
    super.dispose();
  }
}
