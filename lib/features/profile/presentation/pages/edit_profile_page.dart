import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp2/components/my_text_field.dart';
import 'package:newsapp2/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:newsapp2/features/profile/domain/profile_user.dart';
import 'package:newsapp2/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:newsapp2/features/profile/presentation/cubits/profile_states.dart';
import 'package:newsapp2/features/profile/presentation/pages/profile_page.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioTextController = TextEditingController();

  //update profile button pressed
  void updateProfile() async {
    //profile cubit
    final profileCubit = context.read<ProfileCubit>();

    if (bioTextController.text.isNotEmpty) {
      profileCubit.updateUserProfile(
          uid: widget.user.uid, newBio: bioTextController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        //Profile loading
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Uploading..."),
                ],
              ),
            ),
          );
        } else {
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {
              updateProfile(); // Call updateProfile when the button is pressed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          //Profile picture

          //bio
          const Text("Bio"),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              controller: bioTextController,
              hintText: widget.user.bio,
              obscureText: false,
            ),
          ),
        ],
      ),
    );
  }
}
