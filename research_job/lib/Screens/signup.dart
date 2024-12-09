import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:research_job/Screens/login.dart';
import 'package:research_job/Screens/verifyemail.dart';
import 'package:research_job/Widgets/button.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import '../Widgets/text_field.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? _profileImage;
  String? _imageUrl; // To store the uploaded image URL

  // Function to pick and upload a profile image
  Future<void> _pickProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      try {
        // Upload image to Firebase Storage
        String fileName =
            "profile_images/${DateTime.now().millisecondsSinceEpoch}";
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

        await storageRef.putFile(imageFile);

        // Get the image URL after upload
        String imageUrl = await storageRef.getDownloadURL();

        setState(() {
          _profileImage = imageFile;
          _imageUrl = imageUrl; // Save the image URL for later use
        });
      } catch (e) {
        _showErrorDialog("Failed to upload image: $e");
      }
    }
  }

  // Function to handle the signup process with email verification
  signup() async {
    try {
      // Attempt to create a new user with Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // After sign-up, get the user object
      User? user = userCredential.user;

      // Save the user details to Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'location': locationController.text,
          'profileImage': _imageUrl ?? '', // Save the image URL
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Send email verification if not verified
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        // Navigate to VerifyEmail screen
        Get.offAll(const VerifyEmail());
      }
    } catch (e) {
      // Show error dialog if sign-up fails
      _showErrorDialog(e.toString());
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Sign-Up Error",
          style: TextStyle(color: Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Image section
              Container(
                width: double.infinity,
                height: height / 4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Image.asset("assets/signup.png", fit: BoxFit.contain),
                ),
              ),

              const SizedBox(height: 20),

              // Profile Image Section
              GestureDetector(
                onTap: _pickProfileImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              // Name input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFieldInpute(
                  textEditingController: nameController,
                  hintText: "Enter your name",
                  icon: Icons.person,
                ),
              ),

              const SizedBox(height: 15),

              // Email input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFieldInpute(
                  textEditingController: emailController,
                  hintText: "Enter your email",
                  icon: Icons.email,
                ),
              ),

              const SizedBox(height: 15),

              // Phone Number input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFieldInpute(
                  textEditingController: phoneController,
                  hintText: "Enter your phone number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
              ),

              const SizedBox(height: 15),

              // Location input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFieldInpute(
                  textEditingController: locationController,
                  hintText: "Enter your location",
                  icon: Icons.location_on,
                ),
              ),

              const SizedBox(height: 15),

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

              const SizedBox(height: 20),

              // Sign Up button with signup function linked to onTap
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: MyButtons(
                  onTap: signup,
                  text: "Sign Up",
                ),
              ),

              SizedBox(height: height / 20),

              // Login row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      " Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
