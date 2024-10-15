import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp2/components/my_text_field.dart';
import 'package:newsapp2/features/auth/domain/app_user.dart';
import 'package:newsapp2/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:newsapp2/features/post/domain/entities/post.dart';
import 'package:newsapp2/features/post/presentation/cubits/post_cubit.dart';
import 'package:newsapp2/features/post/presentation/cubits/post_states.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // Mobile image pick
  PlatformFile? imagePickedFile;

  // Web image pick
  Uint8List? webImage;

  // Text controller for caption
  final textController = TextEditingController();

  // Current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  // Select image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb, // Loads bytes directly if on web
    );
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  // Create and upload post
  void uploadPost() {
    if (imagePickedFile == null && textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Either an image or caption is required")),
      );
      return;
    }

    // Create post object
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      timestamp: DateTime.now(),
    );

    final postCubit = context.read<PostCubit>();

    // Upload post with or without image
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    } else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post uploaded successfully!")),
    );

    // Clear fields after upload
    textController.clear();
    setState(() {
      imagePickedFile = null;
      webImage = null;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostsLoading || state is PostsUploading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return buildUploadPage();
      },
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        actions: [
          IconButton(onPressed: uploadPost, icon: const Icon(Icons.add)),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            //Image preview for web
            if (kIsWeb && webImage != null) Image.memory(webImage!),

            //Image preview for moble
            if (!kIsWeb &&
                imagePickedFile != null &&
                imagePickedFile!.path != null)
              Image.file(File(imagePickedFile!.path!)),

            //pick image button
            MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            ),

            //Caption textbox
            MyTextField(
                hintText: "Caption",
                obscureText: false,
                controller: textController)
          ],
        ),
      ),
    );
  }
}
