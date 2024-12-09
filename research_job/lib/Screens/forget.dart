import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final TextEditingController emailController = TextEditingController();

  // Function to reset password and send a reset email
  Future<void> reset() async {
    final email = emailController.text;

    // Check if email is empty or not valid
    if (email.isEmpty || !email.contains('@')) {
      _showErrorDialog("Invalid Email", "Please enter a valid email address.");
      return;
    }

    try {
      // Attempt to send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Show success message if email sent successfully
      _showSuccessDialog(
          "Success", "Password reset email sent! Please check your inbox.");
    } catch (e) {
      // Show error message if email sending fails
      _showErrorDialog("Error", e.toString());
    }
  }

  // Function to show a success dialog
  void _showSuccessDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to login screen
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Function to show an error dialog
  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Forgot Password",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add a header with a nice font size and style
            Text(
              "Reset Your Password",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Email input field with a modern design
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter your email",
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.deepPurple),
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepPurple, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: Colors.deepPurpleAccent, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Send Reset Link button with custom styling
            ElevatedButton(
              onPressed: reset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Send Reset Link",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Add some space between the button and the bottom of the screen
            Spacer(),

            // Footer text with a friendly reminder
            Text(
              "Remember your password? ",
              style: TextStyle(fontSize: 16),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Go back to login screen
              },
              child: Text(
                "Log in now",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}