import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:research_job/Screens/home_screen.dart';
import 'package:research_job/Widgets/button_nav_bar.dart';
import 'package:research_job/Widgets/job_widget.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search query";

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: InputDecoration(
          hintText: "Search other member...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white)),
      style: TextStyle(color: Colors.white, fontSize: 16),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
          onPressed: () {
            _clearSearchQuery();
          },
          icon: Icon(Icons.clear))
    ];
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              title: _buildSearchField(),
              actions: _buildActions(),
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
                .where("jobTitle", isGreaterThanOrEqualTo: searchQuery)
                .where("recruitment", isEqualTo: true)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data?.docs.isNotEmpty == true) {
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return JobWidget(
                          jobTitle: snapshot.data?.docs[index]["jobTitle"],
                          jobDescription: snapshot.data?.docs[index]
                              ["jobDescription"],
                          jobId: snapshot.data?.docs[index]["jobId"],
                          uploadedBy: snapshot.data?.docs[index]["uploadedBy"],
                          userImage: snapshot.data?.docs[index]["userImage"],
                          name: snapshot.data?.docs[index]["name"],
                          recruitment: snapshot.data?.docs[index]
                              ["recruitment"],
                          email: snapshot.data?.docs[index]["email"],
                          location: snapshot.data?.docs[index]["location"]);
                    },
                  );
                } else {
                  return Center(
                    child: Text("There is no Member"),
                  );
                }
              }
              return Center(
                child: Text(
                  "Something went wrong",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              );
            },
          ),
        ));
  }
}
