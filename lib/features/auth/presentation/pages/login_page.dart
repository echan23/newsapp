/*
Login page where user logs in with email and password.

Upon successful login the user goes to homepage.

If user doesnt have account they go to register page.

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp2/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:newsapp2/components/my_button.dart';
import 'package:newsapp2/components/my_text_field.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePage;
  LoginPage({super.key, required this.togglePage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  //login button pressed
  void login() {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    //auth cubit
    final authCubit = context.read<AuthCubit>();

    //Nullcheck on email and password fields
    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in the missing fields'),
      ));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),

              // App Name
              const Text(
                "N E W S A P P",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50),

              // Email TextField
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),

              // Password TextField
              MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
              ),

              // Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Sign-in Button
              MyButton(
                text: "Login",
                onTap: login, // Call login method
              ),
              const SizedBox(height: 25),

              // Don't have an account? Register Here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: widget.togglePage,
                    child: const Text(
                      "Register Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
