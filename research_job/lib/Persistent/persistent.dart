import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:research_job/Services/global_variables.dart';

class Persistent {
  static List<String> jobCategoryList = [
    "NIT Rourkela",
    "IIT Bhubaneswar",
    "KIIT University",
    "Trident",
    "Silicon University",
    "VSSUT Burla",
    "centurion university",
    "IIM Sambalpur",
    "GCE Kalahandi",
    "IIT Bombay",
    "LPU",
    "ITER",
    "Pragati College",
    "GCE Kalahandi",
    
  ];


   void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

      name = userDoc.get("name");
      userImage = userDoc.get("userImage");
      location = userDoc.get("location");
  }





  static void updateJobCategoryList(List<String> newCategories) {
    jobCategoryList = newCategories;
  }
}