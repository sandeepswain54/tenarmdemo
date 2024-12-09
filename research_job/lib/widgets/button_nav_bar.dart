import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_job/HomeScreens/profile.dart';
import 'package:research_job/HomeScreens/search_company.dart';
import 'package:research_job/HomeScreens/upload.dart';
import 'package:research_job/Screens/home_screen.dart';
import 'package:research_job/Screens/login.dart';

// ignore: must_be_immutable
class ButtonNavBar extends StatelessWidget {
  int indexNum = 0;

  ButtonNavBar({required this.indexNum});

  void _logout(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
              ],
            ),
            content: Text(
              "Do you want to Log Out?",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            actions: [
              // No button
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  )),
              // Yes button
              TextButton(
                  onPressed: () async {
                    await _auth.signOut(); // Perform sign out
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (Route<dynamic> route) => false, // Clear stack
                    );
                  },
                  child: const Text("Yes",
                      style: TextStyle(color: Colors.green, fontSize: 18))),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.white70,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.white,
      height: 60,
      index: indexNum,
      items: const [
        Icon(
          Icons.list,
          size: 35,
          color: Colors.black,
        ),
        Icon(
          Icons.search,
          size: 35,
          color: Colors.black,
        ),
        Icon(
          Icons.add,
          size: 35,
          color: Colors.black,
        ),
        Icon(
          Icons.person_pin,
          size: 35,
          color: Colors.black,
        ),
        Icon(
          Icons.exit_to_app,
          size: 35,
          color: Colors.black,
        ),
      ],
      animationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => SearchCompany()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => Upload()));
        } else if (index == 3) {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String uid = user!.uid;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => Profile(
                        userID: uid,
                      )));
        } else if (index == 4) {
          _logout(context);
        }
      },
    );
  }
}
