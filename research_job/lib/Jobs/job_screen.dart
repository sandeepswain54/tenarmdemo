import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_job/Jobs/search_job.dart';
import 'package:research_job/widgets/bottom_nav_bar.dart';
import 'package:research_job/widgets/job_widget.dart';

import '../Persistent/persistent.dart';

class JobScreen extends StatefulWidget {
  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String? businessSectorFilter;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: const Text(
            "Business Sector",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          content: SizedBox(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Persistent.BuisnessSector.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      businessSectorFilter = Persistent.BuisnessSector[index];
                    });
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_right_alt_outlined,
                            color: Colors.grey),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            Persistent.BuisnessSector[index],
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                setState(() => businessSectorFilter = null);
                Navigator.pop(context);
              },
              child: const Text("Cancel Filter",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
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
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
            onPressed: () => _showTaskCategoriesDialog(size: size),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => SearchJob())),
              icon: const Icon(Icons.search_outlined, color: Colors.white),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Business") // Ensure collection matches `UploadJob`
              .where("businessSector",
                  isEqualTo:
                      businessSectorFilter) // Ensure field matches `UploadJob`
              .where("recruitment", isEqualTo: true)
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data?.docs.isNotEmpty == true) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = snapshot.data!.docs[index].data();
                    return JobWidget(
                      BuisnessTitle: data["businessTitle"] ?? "No Title",
                      BuisnessDescription:
                          data["businessDescription"] ?? "No Description",
                      JobId: data["jobId"] ?? "No Job ID",
                      uploadBy: data["uploadedBy"] ?? "Unknown",
                      userImage: data["userImage"] ?? "No Image",
                      name: data["name"] ?? "No Name",
                      recruitment: data["recruitment"] ?? false,
                      email: data["email"] ?? "No Email",
                      location: data["location"] ?? "No Location",
                    );
                  },
                );
              } else {
                return const Center(
                    child: Text("No data found.",
                        style: TextStyle(color: Colors.white)));
              }
            } else {
              return const Center(
                  child: Text(
                "Something went wrong.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white),
              ));
            }
          },
        ),
      ),
    );
  }
}
