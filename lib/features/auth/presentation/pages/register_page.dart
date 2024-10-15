import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp2/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:newsapp2/components/my_button.dart';
import 'package:newsapp2/components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePage;
  const RegisterPage({super.key, required this.togglePage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the tree
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  void registerUser() {
    // Get email and password inputs
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPwController.text.trim();

    //Auth cubit
    final authCubit = context.read<AuthCubit>();

    //Null check
    if (email.isEmpty &&
        username.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill out all fields')));
    } else if (password != confirmPassword) {
      //Check that passwords match
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords don't match")));
    } else {
      authCubit.register(username, email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
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
                  "C R E A T E   A C C O U N T",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),

                // Username TextField
                MyTextField(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernameController,
                ),
                const SizedBox(height: 10),

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
                const SizedBox(height: 10),

                // Confirm Password TextField
                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPwController,
                ),
                const SizedBox(height: 10),

                // Register Button
                MyButton(
                  text: "Register",
                  onTap: registerUser,
                ),
                const SizedBox(height: 25),

                // Already have an account? Login Here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.togglePage,
                      child: const Text(
                        "Login Here",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
