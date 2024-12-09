import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_job/Screens/forget.dart';
import 'package:research_job/Screens/home_screen.dart';
import 'package:research_job/Screens/signup.dart';
import 'package:research_job/Widgets/button.dart';
import 'package:research_job/Widgets/text_field.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to handle user login with error handling
  Future<void> loginUser() async {
    try {
      // Attempt to sign in the user
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigate to HomeScreen upon successful login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } catch (e) {
      // Show error dialog if login fails
      _showErrorDialog(e.toString());
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap everything in SingleChildScrollView
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo section
                SizedBox(
                  width: double.infinity,
                  height: height / 3,
                  child: Image.asset("assets/login.png", fit: BoxFit.cover),
                ),

                // Email input field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFieldInpute(
                    textEditingController: emailController,
                    hintText: "Enter your email",
                    icon: Icons.email,
                  ),
                ),

                // Password input field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFieldInpute(
                    textEditingController: passwordController,
                    hintText: "Enter your Password",
                    isPass: true,
                    icon: Icons.lock,
                  ),
                ),

                // Forget Password section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to ForgetPasswordScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Forget(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forget Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),

                // Log In button with authentication logic
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                  child: MyButtons(
                    onTap: loginUser, // Call loginUser when button is pressed
                    text: "Log In",
                  ),
                ),

                SizedBox(height: height / 15),

                // Sign up row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        " Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Adding space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}