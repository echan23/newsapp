import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp2/features/auth/domain/app_user.dart';
import 'package:newsapp2/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:newsapp2/features/profile/presentation/components/bio_box.dart';
import 'package:newsapp2/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:newsapp2/features/profile/presentation/cubits/profile_states.dart';
import 'package:newsapp2/features/profile/presentation/pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Cubit
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  //Current user
  late AppUser? currentUser = authCubit.currentUser;

  @override
  void initState() {
    super.initState();

    //Load user profile
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        //Loaded
        if (state is ProfileLoaded) {
          final user = state.profileUser;
          return Scaffold(
            //Appbar
            appBar: AppBar(
              title: Text(user.name),
              actions: [
                IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user))),
                  icon: const Icon(Icons.settings),
                )
              ],
            ),

            //Body
            body: Column(
              children: [
                //Email
                Center(
                  child: Text(user.email,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                ),

                const SizedBox(height: 25),

                //Profile pic
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 150,
                  width: 150,
                  padding: const EdgeInsets.all(25),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 70,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                //bioBox
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                BioBox(text: user.bio),

                const SizedBox(height: 25),

                //posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        //Loading
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Center(child: Text("No profile found..."));
        }
      },
    );
  }
}
