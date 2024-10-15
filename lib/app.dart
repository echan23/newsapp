import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp2/features/auth/data/firebase_auth_repo.dart';
import 'package:newsapp2/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:newsapp2/features/auth/presentation/cubits/auth_states.dart';
import 'package:newsapp2/features/auth/presentation/pages/auth_page.dart';
import 'package:newsapp2/features/home/pages/home_page.dart';
import 'package:newsapp2/features/post/data/firebase_post_repo.dart';
import 'package:newsapp2/features/post/presentation/cubits/post_cubit.dart';
import 'package:newsapp2/features/profile/data/firebase_profile_repo.dart';
import 'package:newsapp2/features/profile/domain/repos/profile_repo.dart';
import 'package:newsapp2/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:newsapp2/features/storage/data/firebase_storage_repo.dart';
import 'package:newsapp2/themes/dark_mode.dart';
import 'package:newsapp2/themes/light_mode.dart';

/*

APP - root level

Repositories: For database
 - firebase

Bloc Providers: For state management
 - auth
 - profile
 - post
 - search
 - theme

Check Auth State
 - unauthenticated -> auth page
 - authenticated -> home page

*/

class MyApp extends StatelessWidget {
  //auth repo
  final authRepo = FirebaseAuthRepo();
  //profile repo
  final profileRepo = FirebaseProfileRepo();
  //storage repo
  final firebaseStorageRepo = FirebaseStorageRepo();
  //post repo
  final firebasePostRepo = FirebasePostRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //provide cubit to app
    return MultiBlocProvider(
      providers: [
        //Auth cubit
        BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(authRepo: authRepo)..checkAuth()),
        //Profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: profileRepo,
          ),
        ),

        //Post cubit
        BlocProvider<PostCubit>(
            create: (context) => PostCubit(
                postRepo: firebasePostRepo, storageRepo: firebaseStorageRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: ThemeMode.system,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);

            //unauthenticated
            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            //authenticated
            if (authState is Authenticated) {
              return HomePage();
            }

            //loading
            else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },

          //Listen for errors
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
