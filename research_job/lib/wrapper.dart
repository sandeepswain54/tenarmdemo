import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_job/Screens/home_screen.dart';
import 'package:research_job/Screens/login.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show a loading indicator while waiting for authentication state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error if authentication state stream fails
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If user is logged in, navigate to HomeScreen
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            // If user is not logged in, navigate to LoginScreen
            return const LoginScreen();
          }
        },
      ),
    );
  }
}