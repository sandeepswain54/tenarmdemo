import 'package:flutter/material.dart';

class SearchJob extends StatefulWidget {
  

  @override
  State<SearchJob> createState() => _SearchJobState();
}

class _SearchJobState extends State<SearchJob> {
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Search Buisness"),
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