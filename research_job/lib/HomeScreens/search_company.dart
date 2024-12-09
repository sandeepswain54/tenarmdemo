import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:research_job/Widgets/all_company_widget.dart';
import 'package:research_job/Widgets/button_nav_bar.dart';

class SearchCompany extends StatefulWidget {
  @override
  State<SearchCompany> createState() => _SearchCompanyState();
}

class _SearchCompanyState extends State<SearchCompany> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search query";

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: InputDecoration(
          hintText: "Search for Mentor.....",
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
        bottomNavigationBar: ButtonNavBar(indexNum: 1),
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
            
            title: _buildSearchField(),
            actions: _buildActions(),

          ),
          
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance.
          collection("users")
          .where("name",isGreaterThanOrEqualTo: searchQuery)
          .snapshots() ,
           builder: (context,AsyncSnapshot snapshot)
           {
                     if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                     }
                     else if (snapshot.connectionState==ConnectionState.active){
                      if(snapshot.data!.docs.isNotEmpty){
                        return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context,int index){
                                  return AllCompanyWidget(
                                    createdAt:snapshot.data!.docs[index]["uid"] ,
                                   name: snapshot.data!.docs[index]["name"],
                                    email: snapshot.data!.docs[index]["email"],
                                     phone: snapshot.data!.docs[index]["phone"],  
                                      profileImage:snapshot.data!.docs[index]["profileImage"]);
                                },
                        );
                      }
                      else{
                        return Center(
                          child: Text("There is no users"),
                        );
                      }
                     }
                     return Center(
                      child: Text("Something went wrong",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                      ),),
                     );
           })
      ),
    );
  }
}
