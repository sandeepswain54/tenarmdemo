import 'package:flutter/material.dart';
import 'package:research_job/widgets/bottom_nav_bar.dart';

class ProfileCompany extends StatefulWidget {
  const ProfileCompany({super.key});

  @override
  State<ProfileCompany> createState() => _ProfileCompanyState();
}

class _ProfileCompanyState extends State<ProfileCompany> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, Colors.blueAccent.shade100],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Profile Screen",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade900, Colors.blueAccent.shade100],
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                stops: [0.2, 0.9],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
