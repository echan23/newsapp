import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp2/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:newsapp2/components/my_drawer_tile.dart';
import 'package:newsapp2/features/home/pages/home_page.dart';
import 'package:newsapp2/features/profile/presentation/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),

            // Logo
            Icon(
              Icons.person,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            const SizedBox(height: 25),

            // Home tile
            MyDrawerTile(
              title: 'H O M E',
              icon: Icons.home,
              onTap: () {
                Navigator.of(context).pop;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),

            // Profile tile
            MyDrawerTile(
              title: 'P R O F I L E',
              icon: Icons.person,
              onTap: () {
                Navigator.of(context).pop;

                //get current user id
                final user = context.read<AuthCubit>().currentUser;

                if (user == null) {
                  print('Error: User not found');
                  return;
                }

                // Extract uid safely
                final String uid = user.uid;

                // Navigate to the ProfilePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(uid: uid),
                  ),
                );
              },
            ),

            const Spacer(), // Pushes the Logout tile to the bottom

            // Logout tile
            MyDrawerTile(
              title: "L O G O U T",
              icon: Icons.logout, // Corrected the icon
              onTap: () {
                Navigator.of(context).pop;
                // Perform logout using AuthCubit
                context.read<AuthCubit>().logout();
                // Navigate to login screen
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
