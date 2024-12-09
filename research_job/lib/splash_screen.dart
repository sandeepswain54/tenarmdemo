import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:research_job/wrapper.dart';
 // Correct import for the Wrapper

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Adding a delay before moving to Wrapper
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => const Wrapper()); // Navigate to Wrapper after the delay
    });

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Centered Lottie animation and text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie animation
                Lottie.asset(
                  "assets/atr.json", // Ensure this path is correct
                  width: 150, // Adjust size as needed
                  height: 150,
                ),
                const SizedBox(height: 20),
                // Animated text
                const Text(
                  'Welcome to 10arm',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Connect. Collaborate. Contribute',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}