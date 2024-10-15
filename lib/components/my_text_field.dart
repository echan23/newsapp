import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,

          // Default border when enabled (but not focused)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1.5,
            ),
          ),

          // Border when the TextField is focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.blue, // Blue color when focused
              width: 3.5,
            ),
          ),

          // Default border style (if no other states match)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),

          // Internal padding for content inside the TextField
          contentPadding: const EdgeInsets.all(16.0),
        ),

        // Text style for the input
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface, // Text color
        ),
      ),
    );
  }
}
