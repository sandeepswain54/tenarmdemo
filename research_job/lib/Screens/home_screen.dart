import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_job/HomeScreens/search.dart';
import 'package:research_job/Persistent/persistent.dart';
import 'package:research_job/Widgets/button_nav_bar.dart';
import 'package:research_job/Widgets/job_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? jobCategoryFilter;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              "Student Preferences",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        jobCategoryFilter = Persistent.jobCategoryList[index];
                      });

                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      print(
                          "jobCategoryList[index],${Persistent.jobCategoryList[index]}");
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_outlined,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      jobCategoryFilter = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    "Cancel Filter",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Persistent persistentObject = Persistent();
    persistentObject.getMyData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade400,
            Colors.cyan.shade200,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
          bottomNavigationBar: ButtonNavBar(indexNum: 0),
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0), // Custom height
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo.shade400,
                      Colors.cyan.shade200,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.filter_list_rounded,
                    size: 40,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _showTaskCategoriesDialog(size: size);
                  }),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (c) => Search()));
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 40,
                    ))
              ],
              centerTitle: true,
              titleTextStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("jobs")
                  .where("jobCategory", isEqualTo: jobCategoryFilter)
                  .where("recruitment", isEqualTo: true)
                  .orderBy("createdAt", descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data?.docs.isNotEmpty == true) {
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int Index) {
                          return JobWidget(
                            jobTitle: snapshot.data?.docs[Index]["jobTitle"],
                            jobDescription: snapshot.data?.docs[Index]
                                ["jobDescription"],
                            jobId: snapshot.data?.docs[Index]["jobId"],
                            uploadedBy: snapshot.data?.docs[Index]
                                ["uploadedBy"],
                            userImage: snapshot.data?.docs[Index]["userImage"],
                            name: snapshot.data?.docs[Index]["name"],
                            recruitment: snapshot.data?.docs[Index]
                                ["recruitment"],
                            email: snapshot.data?.docs[Index]["email"],
                            location: snapshot.data?.docs[Index]["location"],
                          );
                        });
                  } else {
                    return const Center(
                      child: Text("There is no Recruiter"),
                    );
                  }
                }
                return Center(
                  child: Text(
                    "Something went wrong",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                );
              })),
    );
  }
}
