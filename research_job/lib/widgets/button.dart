// button.dart
import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const MyButtons({
    Key? key,
    required this.onTap, // onTap should be required
    required this.text, // text should also be required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap, // Uses the onTap callback
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Customize as needed
        ), // Customize the button color
      ),
      child: Text(
        text, // Display the text
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white, // Customize the text color
        ),
      ),
    );
  }
}