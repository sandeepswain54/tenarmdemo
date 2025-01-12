import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_job/HomeScreens/profile.dart';
import 'package:research_job/HomeScreens/search_company.dart';
import 'package:research_job/HomeScreens/upload.dart';
import 'package:research_job/News1/home_screen.dart';
import 'package:research_job/Screens/home_screen.dart';
 // Import NewsHomeScreen

// ignore: must_be_immutable
class ButtonNavBar extends StatelessWidget {
  int indexNum = 0;

  ButtonNavBar({required this.indexNum});

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
          Icons.article, // Icon for NewsHomeScreen
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
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => NewsHomeScreen()));
        }
      },
    );
  }
}
