import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:research_job/user_state.dart'; // Import the login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure Firebase initialization is complete before starting the app
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Research App',
      debugShowCheckedModeBanner: false,
      home: UserState(), // Set LoginScreen as the home screen
    );
  }
}
